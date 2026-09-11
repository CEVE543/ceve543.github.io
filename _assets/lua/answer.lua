-- ::: {.answer} is shorthand for a collapsed "Answer" callout, which practice
-- pages carry once per problem. Runs at pre-quarto so the rewritten div goes
-- through Quarto's own callout handling.
function Div(div)
  if not div.classes:includes("answer") then
    return nil
  end
  local attrs = {collapse = "true", title = div.attributes["title"] or "Answer"}
  return pandoc.Div(div.content, pandoc.Attr(div.identifier, {"callout-note"}, attrs))
end
