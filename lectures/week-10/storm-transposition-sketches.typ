// Sketches for the boards in storm-transposition.qmd, one value per drawing.
#import "/_typst/board.typ": *

#let small(body, fill: black) = text(size: 8pt, fill: fill, body)

// A storm drawn as nested rain contours, heaviest in the middle.
#let storm(center, size: 0.5, paint: faint) = {
  import cetz.draw: *
  for (k, s) in (1.0, 0.62, 0.3).enumerate() {
    circle(center, radius: (size * s * 1.4, size * s), stroke: (0.5pt + 0.4pt * k) + paint)
  }
}

// The domain around the watershed, catalog storms where they fell, and one shifted onto the watershed.
#let sketch-domain = cetz.canvas(length: 0.8cm, {
  import cetz.draw: *
  rect((0, 0), (6, 4.2), stroke: 1pt + ink)
  content((5.9, 4.05), small[domain $A_D$], anchor: "north-east")
  circle((3.0, 2.0), radius: (0.55, 0.38), fill: accent.lighten(75%), stroke: 1pt + accent)
  content((3.0, 1.45), small(fill: accent)[watershed], anchor: "north")
  for c in ((1.0, 3.2), (4.9, 3.1), (1.3, 0.9), (4.7, 1.0), (2.2, 3.5)) {
    storm(c, size: 0.45)
  }
  storm((4.9, 3.1), size: 0.45, paint: ink)
  line((4.6, 2.9), (3.35, 2.15), mark: (end: ">"), stroke: 1pt + ink)
  content((3.9, 2.35), small[shift], anchor: "north-west")
  storm((3.0, 2.0), size: 0.45, paint: ink)
})

// Annual loss: a spike of loss-free years, a long right tail, and AAL, VaR, and the tail TVaR averages.
#let sketch-loss = cetz.canvas(length: 0.85cm, {
  import cetz.draw: *
  let f(x) = 2.0 * (x / 0.8) * calc.exp(-x / 0.8) + 0.35 * calc.exp(-x / 2)
  let var = 2.9
  line((var, 0), ..range(31).map(i => {
    let x = var + (5 - var) * i / 30
    (x, f(x))
  }), (5, 0), close: true, fill: accent.lighten(70%), stroke: none)
  curve(f, 0.05, 5, stroke: 1.3pt + ink)
  rect((0, 0), (0.12, 2.4), fill: ink, stroke: none)
  content((0.25, 2.4), small[years with no loss], anchor: "west")
  line((0, 0), (5.3, 0), mark: (end: ">"), stroke: ink)
  content((2.65, -0.75), [annual loss $L$], anchor: "north")
  for (x, label, paint) in ((1.6, [AAL], ink), (var, [VaR], accent), (3.7, [TVaR], accent)) {
    line((x, -0.1), (x, 0.1), stroke: 1.2pt + paint)
    content((x, -0.25), small(fill: paint, label), anchor: "north")
  }
  line((1.6, 0), (1.6, f(1.6)), stroke: (paint: ink, dash: "dashed"))
  line((var, 0), (var, 1.0), stroke: 1pt + accent)
  content((4.2, 0.55), small(fill: accent)[$1 - alpha$], anchor: "south")
})

// Damage against exceedance probability for a ladder of design events, with the trapezoids under it.
#let sketch-damage-curve = cetz.canvas(length: 0.85cm, {
  import cetz.draw: *
  let pts = ((0.35, 3.2), (0.7, 2.4), (1.3, 1.6), (2.3, 0.9), (3.4, 0.4), (4.6, 0))
  for k in range(pts.len() - 1) {
    let (x0, y0) = pts.at(k)
    let (x1, y1) = pts.at(k + 1)
    line((x0, 0), (x0, y0), (x1, y1), (x1, 0), close: true, fill: accent.lighten(80%), stroke: 0.6pt + accent)
  }
  line(..pts, stroke: 1.3pt + ink)
  for p in pts { circle(p, radius: 0.06, fill: ink, stroke: none) }
  rect((0, 0), (0.35, 3.2), fill: none, stroke: (paint: faint, dash: "dashed"))
  content((0.15, 3.6), small(fill: faint)[rarer?], anchor: "south-west")
  axes(5.0, 3.8, xlabel: [exceedance probability $p$], ylabel: [damage $d$])
  content((0.35, 0.15), small[100-yr], anchor: "south-west")
  content((4.6, 0.15), small[2-yr], anchor: "south")
})

// Exceedance rate against intensity, with each storm's rate the step between neighbors.
#let sketch-rates = cetz.canvas(length: 0.85cm, {
  import cetz.draw: *
  let rate(x) = 4 * calc.exp(-x / 1.6)
  curve(rate, 0.3, 5.4, stroke: 1.3pt + ink)
  axes(5.8, 3.6, xlabel: [rainfall $x$], ylabel: [$1 / T$])
  let xs = (3.4, 2.3, 1.2)
  for (k, x) in xs.enumerate() {
    line((x, 0), (x, rate(x)), stroke: (paint: faint, dash: "dotted"))
    line((0, rate(x)), (x, rate(x)), stroke: (paint: faint, dash: "dotted"))
    content((x, -0.3), small[$x_(#(k + 1))$], anchor: "north")
  }
  let levels = (0,) + xs.map(rate)
  for k in range(3) {
    line((-0.35, levels.at(k)), (-0.35, levels.at(k + 1)), stroke: 1.4pt + accent, mark: (start: "|", end: "|"))
    content((-0.45, (levels.at(k) + levels.at(k + 1)) / 2), small(fill: accent)[$lambda_(#(k + 1))$], anchor: "east")
  }
})

// Rainfall return period against damage return period for transposed storms, with the design-storm line.
#let sketch-baer = cetz.canvas(length: 0.8cm, {
  import cetz.draw: *
  line((0, 0), (4, 4), stroke: (paint: accent, dash: "dashed", thickness: 1.2pt))
  content((3.5, 3.2), small(fill: accent)[design storm], anchor: "north-west")
  for (a, b) in pairs(45, 0.3, seed: 23) {
    let (x, y) = (2 + 0.8 * a, 2 + 0.8 * b)
    if x > 0.1 and y > 0.1 and x < 4 and y < 4 {
      circle((x, y), radius: 0.05, fill: ink, stroke: none)
    }
  }
  circle((0.9, 3.8), radius: 0.09, fill: accent, stroke: none)
  content((1.05, 3.8), small(fill: accent)[40-yr rain, 154-yr damage], anchor: "west")
  axes(4.3, 4.3, xlabel: [rainfall $T$], ylabel: [damage $T$])
})
