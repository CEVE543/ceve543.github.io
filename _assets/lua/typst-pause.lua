-- Quarto's reveal markup, turned into Touying pauses for a Typst deck.
--
-- Pandoc's Typst writer drops `.incremental`, `.fragment` and `.pause` and
-- prints a `. . .` line as text, so without this every step of a reveal lands
-- on one page. Touying's `#pause` splits a slide into one PDF page per step.
--
-- - `::: {.fragment}` and `::: {.pause}` (including a callout carrying
--   `.pause`) wait for a step before they appear.
-- - `::: {.incremental}` reveals its list one item at a time.
-- - A paragraph that is exactly `. . .` becomes a pause.
--
-- Runs `at: pre-ast`, while a callout is still a plain div; later, Quarto has
-- replaced it with its own node and the `.pause` class is out of reach.
-- `scripts/publish.jl` drops this filter from the public `_quarto.yml`, so the
-- published decks show each slide once, complete.
if not quarto.doc.is_format("typst") then
  return {}
end

local function pause()
  return pandoc.RawBlock("typst", "#pause")
end

-- Touying ignores a pause inside a list item, so split the list into one-item
-- lists with a pause between them. An ordered list keeps its numbering by
-- starting each piece at its own item number.
local function split_list(list)
  local pieces = pandoc.Blocks({})
  for i, item in ipairs(list.content) do
    if i > 1 then
      pieces:insert(pause())
    end
    if list.t == "OrderedList" then
      local attrs = list.listAttributes
      local start = attrs.start + i - 1
      pieces:insert(pandoc.OrderedList({ item }, pandoc.ListAttributes(start, attrs.style, attrs.delimiter)))
    else
      pieces:insert(pandoc.BulletList({ item }))
    end
  end
  return pieces
end

local function split_lists(blocks)
  local out = pandoc.Blocks({})
  for _, b in ipairs(blocks) do
    if b.t == "BulletList" or b.t == "OrderedList" then
      out:extend(split_list(b))
    else
      out:insert(b)
    end
  end
  return out
end

return {
  {
    Para = function(para)
      if pandoc.utils.stringify(para) == ". . ." then
        return pause()
      end
    end,

    Div = function(div)
      if div.classes:includes("incremental") then
        div.content = split_lists(div.content)
      end
      if div.classes:includes("fragment") or div.classes:includes("pause") then
        return { pause(), div }
      end
      return div
    end,
  },
}
