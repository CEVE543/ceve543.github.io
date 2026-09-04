// =============================================================================
// Text Highlighting
// =============================================================================

#import "_state.typ": _color-theme, _fg-on

#let hltext(body, color: auto) = context {
  let ct = _color-theme.get()
  let c = if color == auto { ct.emphasis } else { color }
  box(
    fill: c,
    inset: (x: 6pt, y: 4pt),
  )[#text(fill: _fg-on(c))[#body]]
}

#let hl(body, color: auto) = context {
  let ct = _color-theme.get()
  let c = if color == auto { ct.accent } else { color }
  box(
    fill: c.lighten(70%),
    inset: (x: 3pt, y: 2pt),
    radius: 2pt,
  )[#body]
}

#let hl-math(body, color: auto) = context {
  let ct = _color-theme.get()
  let c = if color == auto { ct.accent } else { color }
  box(
    fill: c.lighten(80%),
    inset: (x: 2pt, y: 1pt),
  )[#body]
}

#let alert(body) = context {
  let ct = _color-theme.get()
  text(fill: ct.emphasis, weight: "bold")[#body]
}
