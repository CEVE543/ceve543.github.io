-- A page that sets `answers: false` in its frontmatter loses its
-- ::: {.instructor} divs, so a render without a flag gives the student copy.
-- `quarto render ... -M answers:true` keeps them as the answer key, boxed in
-- Typst, where an instructor div otherwise renders as plain text.
-- The key also drops the `#answerbox` blocks from the student copy.
-- Pages with no `answers` key are left alone.
local mode = nil

local function read_meta(meta)
  if meta.answers == nil then
    return nil
  end
  local value = meta.answers
  if type(value) ~= "boolean" then
    value = pandoc.utils.stringify(value) == "true"
  end
  mode = value and "show" or "hide"
end

local function answer_div(div)
  if mode == nil or not div.classes:includes("instructor") then
    return nil
  end
  if mode == "hide" then
    return {}
  end
  if FORMAT:match("typst") then
    return {
      pandoc.RawBlock("typst", "#block(fill: luma(235), inset: 8pt, width: 100%)["),
      div,
      pandoc.RawBlock("typst", "]"),
    }
  end
end

-- The answer key drops the empty answer boxes, so each answer sits under its question.
local function answer_box(raw)
  if mode == "show" and raw.format == "typst" and raw.text:match("^#answerbox") then
    return {}
  end
end

return {{Meta = read_meta}, {Div = answer_div, RawBlock = answer_box}}
