// =============================================================================
// Themed Tables
// =============================================================================
// Styled tables using the active color theme: colored header row,
// alternating body rows, and clean horizontal strokes.

#import "_state.typ": _color-theme, _fg-on

#let dgl-table(..args) = context {
  let ct = _color-theme.get()
  let header-fg = _fg-on(ct.emphasis)

  show table.cell: cell => {
    if cell.y == 0 {
      set text(fill: header-fg, weight: "bold")
      cell
    } else {
      cell
    }
  }
  table(
    inset: (x: 10pt, y: 7pt),
    fill: (_, y) => {
      if y == 0 { ct.emphasis } else if calc.even(y) { ct.emphasis.lighten(92%) } else { white }
    },
    stroke: (x: none, y: 0.5pt + ct.text-muted.lighten(30%)),
    ..args,
  )
}
