// Sketches for the boards in quantile-mapping.qmd, one value per drawing.
#import "/_typst/board.typ": *

#let small(body, fill: black) = text(size: 8pt, fill: fill, body)

// August daily highs: observed mean 34, model 32 historical and 35 future, all in degrees C.
// Temperatures map to the vertical axis as 0.45 per degree above 30.
#let deg(t) = (t - 30) * 0.45

#let sketch-delta = cetz.canvas(length: 0.9cm, {
  import cetz.draw: *
  axes(5, 3.6, xlabel: small[year], ylabel: small[°C])
  // Faint extensions of the historical levels, so each change is measured from one
  line((2.0, deg(32)), (4.7, deg(32)), stroke: (paint: faint, dash: "dashed"))
  line((2.0, deg(34)), (4.7, deg(34)), stroke: (paint: faint, dash: "dashed"))
  line((0.4, deg(32)), (2.0, deg(32)), stroke: 1.5pt + accent)
  line((3.0, deg(35)), (4.6, deg(35)), stroke: 1.5pt + accent)
  line((0.4, deg(34)), (2.0, deg(34)), stroke: 1.5pt + ink)
  line((3.0, deg(37)), (4.6, deg(37)), stroke: (paint: ink, thickness: 1.5pt, dash: "dashed"))
  line((3.5, deg(32)), (3.5, deg(35)), mark: (end: ">"), stroke: accent)
  line((4.2, deg(34)), (4.2, deg(37)), mark: (end: ">"), stroke: ink)
  content((3.45, deg(33.5)), small(fill: accent)[$Delta$], anchor: "east")
  content((4.15, deg(35.5)), small(fill: ink)[$Delta$], anchor: "east")
  content((1.2, deg(32) - 0.1), small(fill: accent)[model], anchor: "north")
  content((1.2, deg(34) + 0.1), small(fill: ink)[observed], anchor: "south")
  content((1.2, -0.1), small[historical], anchor: "north")
  content((3.8, -0.1), small[future], anchor: "north")
})

// Two cumulative distribution functions, scaled so u = 1 sits at height 3.
// The model's is steep (too little spread); the observed one is wider and shifted.
#let logistic(x, c, s) = 1 / (1 + calc.exp(-(x - c) / s))
#let qq-model = (c: 1.8, s: 0.25)
#let qq-obs = (c: 2.3, s: 0.55)
#let qq-x = 2.2
#let qq-u = logistic(qq-x, qq-model.c, qq-model.s)
#let qq-xprime = qq-obs.c + qq-obs.s * calc.ln(qq-u / (1 - qq-u))

#let sketch-qq = cetz.canvas(length: 0.9cm, {
  import cetz.draw: *
  axes(4.8, 3.5, xlabel: small[rainfall], ylabel: small[$F$])
  line((0, 3), (4.6, 3), stroke: (paint: faint, dash: "dashed"))
  content((-0.1, 3), small[1], anchor: "east")
  curve(x => 3 * logistic(x, qq-model.c, qq-model.s), 0, 4.6, stroke: 1.4pt + accent)
  curve(x => 3 * logistic(x, qq-obs.c, qq-obs.s), 0, 4.6, stroke: 1.4pt + ink)
  line((qq-x, 0), (qq-x, 3 * qq-u), stroke: ink)
  line((qq-x, 3 * qq-u), (qq-xprime, 3 * qq-u), mark: (end: ">"), stroke: ink)
  line((qq-xprime, 3 * qq-u), (qq-xprime, 0), mark: (end: ">"), stroke: ink)
  content((-0.1, 3 * qq-u), small[$u$], anchor: "east")
  content((qq-x, -0.1), small[$x$], anchor: "north")
  content((qq-xprime, -0.1), small[$hat(x)$], anchor: "north")
  content((1.15, 2.1), small(fill: accent)[$F_"mod,hist"$], anchor: "east")
  content((3.6, 2.3), small(fill: ink)[$F_"obs"$], anchor: "west")
})
