-- Put a banner at the top of any page whose frontmatter says `status: draft`.
--
-- A draft ships in full, to the instructor site and to the public one, so the
-- banner is the only thing telling a reader the page may still change. It is
-- generated here rather than written into each page so that flipping
-- `status:` to `published` removes it with no other edit.
--
-- Both output formats get one. A reading is downloaded as a Typst PDF and read
-- away from the site, so a banner that only exists in HTML misses the copy a
-- student actually keeps. The Typst version is raw rather than a Div, because
-- Pandoc's Typst writer emits a Div as its bare contents and the warning would
-- read as an ordinary first paragraph.

local TEXT = "Draft. This page is unfinished and will change."

-- Matches the .draft-banner rule in _assets/sass/custom.scss: $accent on a
-- washed fill, $text-muted text.
local TYPST = table.concat({
  '#block(width: 100%, inset: 8pt, radius: 2pt,',
  '  fill: rgb("#e9a139").lighten(85%),',
  '  stroke: (left: 3pt + rgb("#e9a139")))[',
  '  #text(size: 9pt, fill: rgb("#5f6163"))[' .. TEXT .. ']',
  ']',
}, "\n")

function Pandoc(doc)
  local status = doc.meta.status
  if status == nil or pandoc.utils.stringify(status) ~= "draft" then
    return nil
  end

  local banner
  if quarto.doc.is_format("html") then
    banner = pandoc.Div(
      { pandoc.Para({ pandoc.Str(TEXT) }) },
      pandoc.Attr("", { "draft-banner" })
    )
  elseif quarto.doc.is_format("typst") then
    banner = pandoc.RawBlock("typst", TYPST)
  else
    return nil
  end

  table.insert(doc.blocks, 1, banner)
  return doc
end
