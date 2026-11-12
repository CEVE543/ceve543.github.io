-- Quarto's ::: {.columns} div is HTML/revealjs/beamer only; the Typst writer
-- turns it into stacked blocks. Rewrite it as a Typst grid so decks match.
if not quarto.doc.is_format("typst") then
  return {}
end

local function raw(s)
  return pandoc.RawBlock("typst", s)
end

function Div(div)
  if not div.classes:includes("columns") then
    return nil
  end

  local widths, out = {}, {}
  -- typst-pause.lua runs first and puts a `.pause` column's `#pause` just
  -- before the column, where this loop would drop it; carry it into the cell.
  local pending_pause = false
  for _, col in ipairs(div.content) do
    if col.t == "RawBlock" and col.format == "typst" and col.text == "#pause" then
      pending_pause = true
    elseif col.t == "Div" and col.classes:includes("column") then
      if pending_pause then
        col.content:insert(1, raw("#pause"))
        pending_pause = false
      end
      -- Widths are written as percentages, which is the Quarto idiom, but a
      -- Typst percentage track is measured against the whole container and
      -- the gutters are added on top, so columns summing to 100% run off the
      -- slide. Reading `40%` as `40fr` keeps the same proportions and lets
      -- the grid take the gutters out of the space first.
      local w = col.attributes["width"] or "1fr"
      w = w:gsub("^(%d+%.?%d*)%%$", "%1fr")
      table.insert(widths, w)
      table.insert(out, col.content)
    end
  end
  if #out == 0 then
    return nil
  end

  local blocks = { raw("#grid(columns: (" .. table.concat(widths, ", ") .. "), gutter: 1em)[") }
  for i, content in ipairs(out) do
    if i > 1 then
      table.insert(blocks, raw("][")) 
    end
    for _, b in ipairs(content) do
      table.insert(blocks, b)
    end
  end
  table.insert(blocks, raw("]"))
  return blocks
end
