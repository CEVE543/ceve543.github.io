// Sketches for the boards in joint-distributions.qmd, one value per drawing.
#import "/_typst/board.typ": *

// Points outside the box from (0.1, 0.1) to max are dropped, so none land off the axes.
#let scatter-dots(pts, size: 0.05, max: (4.5, 3.8)) = {
  import cetz.draw: *
  for (x, y) in pts.filter(((x, y)) => x > 0.1 and y > 0.1 and x < max.at(0) and y < max.at(1)) {
    circle((x, y), radius: size, fill: ink, stroke: none)
  }
}

// Rain-surge pairs on the normal scale; each sketch maps them to its own axes.
// Pairs that would land off the rain-surge axes are dropped here, so every sketch shows the same points.
#let to-plot((a, b)) = (2 + 0.75 * a, 1.8 + 0.7 * b)
#let rain-surge-z = pairs(45, 0.65).filter(p => {
  let (x, y) = to-plot(p)
  x > 0.1 and y > 0.1 and x < 4.5 and y < 3.8
})

// A logistic stand-in for the standard normal CDF, close enough for a sketch.
#let phi(z) = 1 / (1 + calc.exp(-1.702 * z))

#let small(body, fill: black) = text(size: 8pt, fill: fill, body)
#let label-box(body) = box(fill: white, inset: 1.5pt, body)

#let sketch-joint = cetz.canvas(length: 0.9cm, {
  import cetz.draw: *
  rect((2.4, 2.2), (4.6, 3.8), fill: accent.lighten(80%), stroke: none)
  rect((0, 0), (2.4, 2.2), fill: ink.lighten(88%), stroke: none)
  scatter-dots(rain-surge-z.map(to-plot))
  axes(4.8, 4, xlabel: [rain $x$], ylabel: [surge $y$])
  line((2.4, 0), (2.4, 3.8), stroke: (dash: "dashed", paint: faint))
  line((0, 2.2), (4.6, 2.2), stroke: (dash: "dashed", paint: faint))
  content((0.6, 0.35), label-box(small[$F(x, y)$]))
  content((3.5, 3.4), small(fill: accent)[both above])
})

#let sketch-slice = cetz.canvas(length: 0.9cm, {
  import cetz.draw: *
  rect((2.3, 0), (2.7, 4), fill: accent.lighten(85%), stroke: none)
  scatter-dots(rain-surge-z.map(to-plot))
  axes(4.8, 4, xlabel: [rain $x$], ylabel: [surge $y$])
  line(..range(41).map(i => (2.7 + 1.1 * gauss(i / 10, 2.3, 0.5), i / 10)), stroke: 1.3pt + accent)
  line(..range(41).map(i => (4.6 - 0.9 * gauss(i / 10, 1.8, 0.75), i / 10)), stroke: (paint: faint, dash: "dashed"))
  content((3.6, 3.7), small(fill: accent)[$f(y | x)$])
  content((4.4, 0.25), small(fill: faint)[$f_Y$], anchor: "east")
})

#let sketch-bumps = cetz.canvas(length: 0.85cm, {
  import cetz.draw: *
  let xs = (0.6, 1.0, 1.2, 1.9, 2.3, 2.45, 3.4)
  // Bumps and their sum share one scale, so the drawing is the estimate.
  for xi in xs {
    curve(x => 0.45 * gauss(x, xi, 0.3), 0, 4.2, stroke: (paint: faint, thickness: 0.6pt))
    line((xi, -0.12), (xi, 0.12), stroke: 1.2pt + ink)
  }
  curve(x => 0.45 * xs.map(xi => gauss(x, xi, 0.3)).sum(), 0, 4.2, stroke: 1.4pt + accent)
  line((0, 0), (4.3, 0), stroke: ink)
  content((4.3, -0.2), small[$x$], anchor: "north-east")
})

// Four common kernels, each a density with area 1 drawn on the same scale.
#let sketch-kernels = cetz.canvas(length: 0.42cm, {
  import cetz.draw: *
  let shapes = (
    ("normal", t => gauss(t, 0, 0.4) / (0.4 * calc.sqrt(2 * calc.pi))),
    ("box", t => if calc.abs(t) < 1 { 0.5 } else { 0 }),
    ("triangle", t => calc.max(0, 1 - calc.abs(t))),
    ("Epanechnikov", t => calc.max(0, 0.75 * (1 - t * t))),
  )
  for (k, (name, f)) in shapes.enumerate() {
    let x0 = 2.9 * k
    line((x0 - 1.3, 0), (x0 + 1.3, 0), stroke: faint)
    line(..range(105).map(i => {
      let t = -1.3 + 2.6 * i / 104
      (x0 + t, 1.4 * f(t))
    }), stroke: 1.2pt + ink)
    content((x0, -0.3), text(size: 6.5pt, name), anchor: "north")
  }
})

#let sketch-kde-2d = cetz.canvas(length: 0.8cm, {
  import cetz.draw: *
  let hatch = tiling(size: (5pt, 5pt), std.line(start: (0pt, 0pt), end: (5pt, 5pt), stroke: 0.4pt + faint))
  rect((3.9, 0), (4.8, 4), fill: hatch, stroke: none)
  let pts = pairs(30, 0.65, seed: 11).map(((a, b)) => (2 + 0.6 * a, 1.9 + 0.6 * b))
  let center = (pts.map(p => p.at(0)).sum() / pts.len(), pts.map(p => p.at(1)).sum() / pts.len())
  scatter-dots(pts, max: (3.8, 3.9))
  group({
    rotate(35deg, origin: center)
    for (a, b) in ((0.7, 0.35), (1.3, 0.7), (1.9, 1.0)) {
      circle(center, radius: (a, b), stroke: 0.8pt + accent)
    }
  })
  rect((2.6, 0), (2.9, 4), stroke: (paint: ink, dash: "dashed"))
  axes(4.8, 4, xlabel: [$x$], ylabel: [$y$])
  content((4.35, 3.6), small[no data])
})

// Storm intensity drives rain and surge; each node carries its piece of the joint.
#let dag-storm = diagram(spacing: (2.6em, 2.4em), node-stroke: 1pt + ink, node-inset: 6pt,
  node((1, 0), [storm $W$], name: <w>),
  node((0, 1), [rain $X$], name: <r>),
  node((2, 1), [surge $Y$], name: <s>),
  edge(<w>, <r>, "-|>"),
  edge(<w>, <s>, "-|>"),
  node((1, -0.65), text(fill: accent)[$f(w)$], stroke: none),
  node((0, 1.7), text(fill: accent)[$f(x | w)$], stroke: none),
  node((2, 1.7), text(fill: accent)[$f(y | w)$], stroke: none),
)

// A skewed density under the CDF maps to a flat density beside the u axis.
#let sketch-pit = cetz.canvas(length: 0.8cm, {
  import cetz.draw: *
  let s = 0.8
  let cdf(x) = 3.6 * (1 - (1 + x / s) * calc.exp(-x / s))
  let pdf(x) = 1.6 * (x / s) * calc.exp(-x / s)
  curve(cdf, 0, 4.6, stroke: 1.4pt + ink)
  line((0, 3.6), (4.6, 3.6), stroke: (paint: faint, dash: "dotted"))
  let x0 = 1.6
  line((x0, 0), (x0, cdf(x0)), (0, cdf(x0)), stroke: 1pt + accent, mark: (end: ">"))
  axes(4.8, 4.0, xlabel: [$x$], ylabel: [$u$])
  content((3.9, 3.2), [$F_X$])
  // f_X below the x axis
  curve(x => -1.6 + pdf(x), 0, 4.6, stroke: 1.2pt + faint)
  line((0, -1.6), (4.6, -1.6), stroke: faint)
  content((4.6, -1.25), small(fill: faint)[$f_X$: skewed], anchor: "east")
  // The density of U, drawn sideways beside the u axis
  line((-1.5, 0), (-0.8, 0), (-0.8, 3.6), (-1.5, 3.6), stroke: 1.2pt + faint)
  line((-1.5, 0), (-1.5, 3.6), stroke: faint)
  content((-1.15, 3.7), small(fill: faint)[flat], anchor: "south")
})

// The rain-surge scatter, each coordinate through its own CDF, lands on the unit square.
#let sketch-sklar = cetz.canvas(length: 0.62cm, {
  import cetz.draw: *
  scatter-dots(rain-surge-z.map(to-plot), size: 0.06)
  axes(4.8, 4, xlabel: [$x$], ylabel: [$y$])
  line((5.3, 2.4), (7.3, 2.4), mark: (end: ">"), stroke: 1pt + accent)
  content((6.3, 2.6), small(fill: accent)[$F_X, F_Y$], anchor: "south")
  line((7.3, 1.4), (5.3, 1.4), mark: (end: ">"), stroke: (paint: accent, dash: "dashed"))
  content((6.3, 1.2), small(fill: accent)[$F_X^(-1), F_Y^(-1)$], anchor: "north")
  let x0 = 8.4
  rect((x0, 0), (x0 + 3.8, 3.8), stroke: ink)
  for (a, b) in rain-surge-z {
    circle((x0 + 3.8 * phi(a), 3.8 * phi(b)), radius: 0.06, fill: ink, stroke: none)
  }
  content((x0 + 1.9, -0.3), [$u$], anchor: "north")
  content((x0 - 0.3, 1.9), [$v$], anchor: "east")
  content((x0 + 3.8, -0.3), small[1], anchor: "north")
})

#let sketch-normal-pairs = cetz.canvas(length: 0.6cm, {
  import cetz.draw: *
  scatter-dots(pairs(60, 0.7, seed: 5).map(((a, b)) => (2.5 + 0.8 * a, 2.5 + 0.8 * b)), size: 0.06, max: (4.9, 4.9))
  axes(5, 5, xlabel: [$z_1$], ylabel: [$z_2$])
})

// Upper tail dependence: of the points right of q, the share that are also above q.
#let sketch-tail = cetz.canvas(length: 0.9cm, {
  import cetz.draw: *
  let q = 0.83 * 3.6
  rect((q, 0), (3.6, 3.6), fill: ink.lighten(75%), stroke: none)
  rect((q, q), (3.6, 3.6), fill: accent.lighten(70%), stroke: 1pt + accent)
  rect((0, 0), (3.6, 3.6), stroke: ink)
  for (a, b) in pairs(160, 0.7, seed: 9) {
    circle((3.6 * phi(a), 3.6 * phi(b)), radius: 0.035, fill: ink, stroke: none)
  }
  content((q, -0.3), small[$q$], anchor: "north")
  content((-0.3, q), small[$q$], anchor: "east")
  content((1.8, -0.7), [$u$], anchor: "north")
  content((-0.7, 1.8), [$v$], anchor: "east")
})
