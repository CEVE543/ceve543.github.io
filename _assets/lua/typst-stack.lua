-- A `::: {.stack}` div piles its `::: {.photo}` children as overlapping Typst
-- placements, which is what a row of snapshots wants and what a grid of
-- columns cannot do. Each photo carries `dx`/`dy` offsets and an optional
-- `uncover` overlay spec for a Touying incremental reveal.
--
-- Photos are placed first and captions second, so a caption always draws over
-- the photo that overlaps it rather than disappearing underneath. Each caption
-- gets a near-opaque white backing for the same reason.
if not quarto.doc.is_format("typst") then
  return {}
end

local function raw(s)
  return pandoc.RawBlock("typst", s)
end

local function place_open(photo, dy)
  local open = "#place(top + left, dx: " .. (photo.attributes["dx"] or "0cm") ..
    ", dy: " .. dy .. ")["
  if photo.attributes["uncover"] then
    return open .. '#uncover("' .. photo.attributes["uncover"] .. '")[', "]]"
  end
  return open, "]"
end

function Div(div)
  if not div.classes:includes("stack") then
    return nil
  end

  local photos, captions = {}, {}

  for _, photo in ipairs(div.content) do
    if photo.t == "Div" and photo.classes:includes("photo") then
      local dy = photo.attributes["dy"] or "0cm"
      local open, close = place_open(photo, dy)
      table.insert(photos, raw(open))
      for _, b in ipairs(photo.content) do
        if b.t == "Figure" then
          -- Strip the figure wrapper: the caption is re-placed below, and a
          -- figure inside a placement would also pick up the theme's caption
          -- layout, which assumes a block that owns its own width.
          for _, inner in ipairs(b.content) do
            table.insert(photos, inner)
          end
          -- The image's own `height` says how far below the photo's top edge
          -- its caption belongs.
          local h = "0cm"
          b:walk({ Image = function(img) h = img.attributes["height"] or h end })
          local cap_open, cap_close = place_open(photo, dy .. " + " .. h .. " + 0.15cm")
          table.insert(captions, raw(cap_open ..
            "#box(fill: white.transparentize(10%), inset: (x: 4pt, y: 2pt), radius: 2pt)[#text(size: 11pt, fill: luma(80))["))
          table.insert(captions, pandoc.Plain(b.caption.long[1].content))
          table.insert(captions, raw("]]" .. cap_close))
        else
          table.insert(photos, b)
        end
      end
      table.insert(photos, raw(close))
    end
  end

  local blocks = { raw("#block(width: 100%, height: " .. (div.attributes["height"] or "8cm") .. ")[") }
  for _, b in ipairs(photos) do table.insert(blocks, b) end
  for _, b in ipairs(captions) do table.insert(blocks, b) end
  table.insert(blocks, raw("]"))
  return blocks
end
