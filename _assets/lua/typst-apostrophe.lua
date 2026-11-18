-- Keep an apostrophe after a digit an apostrophe in Typst.
-- Pandoc writes "ECHAM4.5's" with a straight quote, and Typst renders a
-- quote after a digit as a prime (4.5′s). Emitting the curly apostrophe as
-- raw Typst bypasses smart quotes. No-ops for every other format.
if not quarto.doc.is_format("typst") then
  return {}
end

local APOS = "’"

function Str(el)
  local text = el.text:gsub("(%d)'", "%1" .. APOS)
  if not text:find("%d" .. APOS) then
    return nil
  end
  local out = {}
  local pos = 1
  while true do
    local s, e = text:find("%d" .. APOS, pos)
    if not s then
      break
    end
    table.insert(out, pandoc.Str(text:sub(pos, s)))
    table.insert(out, pandoc.RawInline("typst", APOS))
    pos = e + 1
  end
  if pos <= #text then
    table.insert(out, pandoc.Str(text:sub(pos)))
  end
  return out
end
