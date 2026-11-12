// Helpers for whiteboard board maps on `kind: notes` lecture pages.
// A page imports this from a raw Typst block: #import "/_typst/board.typ": *
// Each board is drawn as it should look when finished.

#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#let ink = rgb("#1f3a5f")
#let accent = rgb("#b5452c")
#let faint = luma(150)

// One physical board, finished. Pass columns as positional content.
#let board(widths: auto, ..cols) = {
  let cols = cols.pos()
  block(
    width: 100%,
    breakable: false,
    stroke: 1.5pt + luma(110),
    radius: 3pt,
    fill: luma(253),
    inset: 12pt,
    grid(
      columns: if widths == auto { (1fr,) * cols.len() } else { widths },
      column-gutter: 14pt,
      stroke: (x, y) => if x > 0 { (left: (paint: luma(200), dash: "dashed")) },
      inset: (x: 6pt),
      ..cols.map(c => align(horizon, c)),
    ),
  )
}

// A result that gets a box drawn around it on the board.
#let key(body) = box(stroke: 1.2pt + accent, inset: 7pt, radius: 2pt, body)

// Deterministic standard normals (linear congruential generator and Box-Muller),
// so sketches look the same on every render.
#let normals(n, seed: 1) = {
  let state = seed
  let out = ()
  for i in range(n) {
    state = calc.rem(1103515245 * state + 12345, 2147483648)
    let a = (state + 1) / 2147483649
    state = calc.rem(1103515245 * state + 12345, 2147483648)
    let b = (state + 1) / 2147483649
    out.push(calc.sqrt(-2 * calc.ln(a)) * calc.cos(2 * calc.pi * b))
  }
  out
}

// Pairs with correlation rho, standard normal marginals.
#let pairs(n, rho, seed: 7) = {
  let z1 = normals(n, seed: seed)
  let w = normals(n, seed: seed + 101)
  z1.zip(w).map(((a, b)) => (a, rho * a + calc.sqrt(1 - rho * rho) * b))
}

// Axes from the origin, with labels at the ends. Call inside a cetz canvas.
#let axes(w, h, xlabel: none, ylabel: none) = {
  import cetz.draw: *
  line((0, 0), (w, 0), mark: (end: ">"), stroke: ink)
  line((0, 0), (0, h), mark: (end: ">"), stroke: ink)
  if xlabel != none { content((w, -0.3), xlabel, anchor: "north-east") }
  if ylabel != none { content((-0.25, h), ylabel, anchor: "north-east") }
}

// A curve through the values of f on [a, b]. Call inside a cetz canvas.
#let curve(f, a, b, n: 60, ..style) = {
  import cetz.draw: *
  line(..range(n + 1).map(i => {
    let x = a + (b - a) * i / n
    (x, f(x))
  }), ..style)
}

#let gauss(x, m, s) = calc.exp(-calc.pow((x - m) / s, 2) / 2)
