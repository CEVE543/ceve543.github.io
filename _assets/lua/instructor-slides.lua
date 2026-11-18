-- Turn `::: {.instructor}` divs into Touying speaker notes on lecture decks.
--
-- Touying treats a block-level div after a `##` as the start of a new slide,
-- so an instructor note left alone does not sit quietly at the foot of its
-- slide: it produces a second slide carrying the previous title with the note
-- printed on it, in front of the room. Wrapping the note in `#speaker-note[]`
-- keeps it with its slide and off the projected page. The theme already wires
-- `show-notes-on-second-screen`, so presenter mode can show it.
--
-- Only decks. A `kind: notes` page is Typst too, and its whole body lives in
-- an instructor div, so wrapping there would hide the page. No-ops for every
-- other format; the sanitizer still strips the div from the published copy.

local is_deck = false

function Meta(meta)
  local kind = meta.kind
  if kind ~= nil then
    kind = pandoc.utils.stringify(kind)
    is_deck = (kind == "slides" or kind == "working")
  end
end

-- A div whose first block is a heading is a whole instructor-only slide, not a
-- note attached to one. It projects like any other slide and is stripped from
-- the published copy by the sanitizer, the same bargain the `.instructor`
-- images make.
local function starts_a_slide(el)
  return el.content[1] ~= nil and el.content[1].t == "Header"
end

function Div(el)
  if not (is_deck and quarto.doc.is_format("typst") and el.classes:includes("instructor")) then
    return nil
  end
  if starts_a_slide(el) then
    -- Unwrap. Quarto renders a div as a Typst `#block[]`, and a `##` heading
    -- inside one starts its slide without carrying the rest of the block onto
    -- it, so the slide comes out empty.
    return el.content
  end
  local out = pandoc.List({ pandoc.RawBlock("typst", "#speaker-note[") })
  out:extend(el.content)
  out:insert(pandoc.RawBlock("typst", "]"))
  return out
end

return { { Meta = Meta }, { Div = Div } }
