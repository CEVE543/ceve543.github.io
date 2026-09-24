// =============================================================================
// Figure Components
// =============================================================================

#import "_state.typ": _color-theme

// caption-text: figure-caption styling for prose that is not attached to a
// figure (a source note, a standing caveat). Same size and colour capfig uses,
// so captions match wherever they appear.
#let caption-text(body) = context {
  text(size: 10pt, fill: _color-theme.get().text-muted)[#body]
}

#let capfig(
  source,
  title: none,
  caption: none,
  width: auto,
) = context {
  let ct = _color-theme.get()
  set align(left)
  stack(
    spacing: 12pt,
    if title != none {
      text(weight: "bold", fill: ct.emphasis, size: 18pt)[#title]
    },
    if width == auto {
      source
    } else {
      box(width: width)[#source]
    },
    if caption != none {
      caption-text[#caption]
    },
  )
}

#let figgrid(
  columns: 2,
  gutter: 12pt,
  ..figures,
) = {
  let items = figures.pos()
  grid(
    columns: (1fr,) * columns,
    gutter: gutter,
    ..items
  )
}

#let figitem(
  source,
  title: none,
  caption: none,
) = capfig(source, title: title, caption: caption)
