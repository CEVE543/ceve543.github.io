// Sketches for markov-chains.qmd, one value per drawing.
#import "/_typst/board.typ": *

#let small(body, fill: black) = text(size: 8pt, fill: fill, body)

// Deterministic uniforms (linear congruential generator), so sketches look the same on every render.
#let uniforms(n, seed: 1) = {
  let state = seed
  let out = ()
  for i in range(n) {
    state = calc.rem(1103515245 * state + 12345, 2147483648)
    out.push((state + 1) / 2147483649)
  }
  out
}

// Wet/dry chain: the coin used after a dry day lands wet with 0.2, after a wet day with 0.6.
#let sketch-chain = diagram(
  node-stroke: 1pt + ink,
  spacing: 5em,
  node((0, 0), [dry \ 0], shape: circle),
  node((1, 0), [wet \ 1], shape: circle),
  edge((0, 0), (1, 0), "-|>", $p_(01) = 0.2$, bend: 30deg),
  edge((1, 0), (0, 0), "-|>", $p_(10) = 0.4$, bend: 30deg),
  edge((0, 0), (0, 0), "-|>", $p_(00) = 0.8$, bend: 130deg),
  edge((1, 0), (1, 0), "-|>", $p_(11) = 0.6$, bend: 130deg),
)

// Forty simulated days from the same uniforms: the chain, and independent days with the same wet fraction, 1/3.
#let n-days = 40
#let u-days = uniforms(n-days, seed: 98)
#let chain-days = {
  let out = (false,)
  for i in range(1, n-days) {
    let p = if out.at(i - 1) { 0.6 } else { 0.2 }
    out.push(u-days.at(i) < p)
  }
  out
}
#let indep-days = u-days.map(u => u < 1 / 3)

#let day-row(days, y, label) = {
  import cetz.draw: *
  content((-0.2, y + 0.15), small(label), anchor: "east")
  for (i, wet) in days.enumerate() {
    let x = i * 0.25
    rect((x, y), (x + 0.22, y + 0.3), fill: if wet { ink } else { luma(235) }, stroke: none)
  }
}

#let sketch-sequences = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  day-row(chain-days, 0.6, [Markov chain])
  day-row(indep-days, 0, [independent days])
  content((5, -0.35), small[day $arrow.r$ #h(1em) dark = wet], anchor: "north")
})

// Dry spells: P(a dry spell lasts at least n days), the chain (stays dry with 0.8)
// against independent days with the same wet fraction (stay dry with 2/3).
#let sketch-spells = cetz.canvas(length: 0.8cm, {
  import cetz.draw: *
  axes(6.4, 3.4, ylabel: small[$P("length" >= n)$])
  content((3.2, -0.8), small[dry spell length $n$ (days)])
  let to-plot(n, p) = (n * 0.5, 3 * p)
  for (q, col) in ((0.8, ink), (2 / 3, accent)) {
    line(..range(1, 12).map(n => to-plot(n, calc.pow(q, n - 1))), stroke: 1.5pt + col)
    for n in range(1, 12) { circle(to-plot(n, calc.pow(q, n - 1)), radius: 0.05, fill: col, stroke: none) }
  }
  line(to-plot(7, 0), to-plot(7, 0.85), stroke: (dash: "dashed", paint: faint))
  content((3.5, -0.35), small[7])
  content((3.65, 1.05), small(fill: ink)[0.26], anchor: "west")
  content((3.65, 0.45), small(fill: accent)[0.088], anchor: "west")
  content((3.3, 3.1), small(fill: ink)[chain: mean 5 days], anchor: "west")
  content((3.3, 2.65), small(fill: accent)[independent: mean 3 days], anchor: "west")
  content((-0.15, 3), small[1], anchor: "east")
})

// Hidden coins: thirty days of the hidden regime (stays with 0.9) and the rain it produces
// (0.8 when stormy, 0.1 when settled).
#let n-hid = 30
#let u-regime = uniforms(n-hid, seed: 5)
#let u-rain = uniforms(n-hid, seed: 23)
#let regimes = {
  let out = (true,)
  for i in range(1, n-hid) {
    out.push(if u-regime.at(i) < 0.9 { out.at(i - 1) } else { not out.at(i - 1) })
  }
  out
}
#let rains = range(n-hid).map(i => u-rain.at(i) < (if regimes.at(i) { 0.8 } else { 0.1 }))

#let sketch-hidden = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  content((-0.2, 0.85), small(fill: faint)[hidden regime], anchor: "east")
  content((-0.2, 0.15), small[what you see], anchor: "east")
  for i in range(n-hid) {
    let x = i * 0.26
    rect((x, 0.7), (x + 0.26, 1.0), fill: if regimes.at(i) { accent.lighten(55%) } else { luma(240) }, stroke: none)
    if rains.at(i) {
      circle((x + 0.13, 0.15), radius: 0.08, fill: ink, stroke: none)
    } else {
      circle((x + 0.13, 0.15), radius: 0.08, fill: none, stroke: 0.6pt + faint)
    }
  }
  content((8.0, 0.85), small(fill: accent)[stormy], anchor: "west")
  content((8.0, 0.15), small[● rain #h(0.4em) ○ none], anchor: "west")
})

// The HMM as a graph: a row of hidden states joined by A, each emitting the day's weather below it.
#let sketch-hmm = diagram(
  node-stroke: 1pt + ink,
  spacing: (2.6em, 3em),
  node((0, 0), $S_1$, shape: circle),
  node((1, 0), $S_2$, shape: circle),
  node((2, 0), $S_3$, shape: circle),
  node((3, 0), $dots$, stroke: none),
  node((0, 1), $y_1$, stroke: none),
  node((1, 1), $y_2$, stroke: none),
  node((2, 1), $y_3$, stroke: none),
  edge((0, 0), (1, 0), "-|>", $A$),
  edge((1, 0), (2, 0), "-|>", $A$),
  edge((2, 0), (3, 0), "-|>"),
  edge((0, 0), (0, 1), "-|>", $f_(S_1)$),
  edge((1, 0), (1, 1), "-|>", $f_(S_2)$),
  edge((2, 0), (2, 1), "-|>", $f_(S_3)$),
  node((-0.9, 0), small(fill: faint)[hidden], stroke: none),
  node((-0.9, 1), small(fill: faint)[seen], stroke: none),
)

// Trellis for R R R N N N R R R: every state sequence is a path through the grid.
// Two competing paths: stay stormy throughout, or switch to settled for the three dry days.
// The forward algorithm sums over all 2^9 paths; Viterbi keeps the single best one.
#let sketch-trellis = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let obs = ("R", "R", "R", "N", "N", "N", "R", "R", "R")
  let T = obs.len()
  let dx = 0.9
  let ys = (1.2, 0)   // stormy on top, settled below
  let stay = (0,) * T
  let switch = (0, 0, 0, 1, 1, 1, 0, 0, 0)
  for t in range(T - 1) {
    for i in range(2) {
      for j in range(2) {
        line((t * dx, ys.at(i)), ((t + 1) * dx, ys.at(j)), stroke: 0.4pt + luma(205))
      }
    }
    line((t * dx, ys.at(stay.at(t))), ((t + 1) * dx, ys.at(stay.at(t + 1))), stroke: 1.8pt + ink)
    line((t * dx, ys.at(switch.at(t))), ((t + 1) * dx, ys.at(switch.at(t + 1))), stroke: (paint: accent, thickness: 1.8pt, dash: "dashed"))
  }
  for t in range(T) {
    for i in range(2) {
      circle((t * dx, ys.at(i)), radius: 0.11, fill: white, stroke: 1pt + ink)
    }
    content((t * dx, -0.45), small[#obs.at(t)])
  }
  content((-0.3, 1.2), small[stormy], anchor: "east")
  content((-0.3, 0), small[settled], anchor: "east")
  content((-0.3, -0.45), small[seen], anchor: "east")
  content(((T - 1) * dx + 0.4, 1.35), small(fill: ink)[stay stormy: 0.0052], anchor: "west")
  content(((T - 1) * dx + 0.4, 0.95), small(fill: accent)[swap and back: 0.0059], anchor: "west")
  content(((T - 1) * dx + 0.4, 0.3), small(fill: faint)[all $2^9$ paths: forward], anchor: "west")
  content(((T - 1) * dx + 0.4, -0.05), small(fill: faint)[best one: Viterbi], anchor: "west")
})

// P(stormy) for each day of R R R N N N R R R, with stormy and settled regimes
// (stay with 0.9; rain with 0.8 when stormy, 0.1 when settled). Values from the setup cell.
#let posterior-stormy = (0.976, 0.981, 0.922, 0.431, 0.347, 0.431, 0.922, 0.981, 0.976)
#let viterbi-stormy = (1, 1, 1, 0, 0, 0, 1, 1, 1)
#let rain-seq = ("R", "R", "R", "N", "N", "N", "R", "R", "R")

#let sketch-posterior = cetz.canvas(length: 0.8cm, {
  import cetz.draw: *
  axes(7.6, 3.4, ylabel: small[$P("stormy" | y_(1:9))$])
  line((0, 3), (7.3, 3), stroke: (dash: "dotted", paint: faint))
  content((-0.15, 3), small[1], anchor: "east")
  line((0, 1.5), (7.3, 1.5), stroke: (dash: "dotted", paint: faint))
  content((-0.15, 1.5), small[0.5], anchor: "east")
  for i in range(9) {
    let x = 0.4 + i * 0.8
    rect((x, 0), (x + 0.5, 3 * posterior-stormy.at(i)), fill: ink.lighten(30%), stroke: none)
    content((x + 0.25, -0.35), small[#rain-seq.at(i)])
    let v = 3 * viterbi-stormy.at(i)
    line((x - 0.05, v), (x + 0.55, v), stroke: 2pt + accent)
  }
  content((2.75, 2.2), small(fill: accent)[Viterbi], anchor: "west")
})

// Two-state NHMM, settled is the reference: alpha_12 = ln(1/9), alpha_22 = ln 9, beta = 0.5 per °C.
#let logistic(z) = 1 / (1 + calc.exp(-z))
#let p12(x) = logistic(calc.ln(1 / 9) + 0.5 * x)
#let p22(x) = logistic(calc.ln(9) + 0.5 * x)
#let pi-stormy(x) = p12(x) / (1 + p12(x) - p22(x))

// x from -2 to 2 maps to 0 to 5; probability 0 to 1 maps to 0 to 3.
#let x-to-plot(x) = (x + 2) * 1.25

#let sketch-transitions = cetz.canvas(length: 0.9cm, {
  import cetz.draw: *
  axes(5.4, 3.4, ylabel: small[probability])
  content((2.5, -0.75), small[Niño 3.4, $x$ (°C)])
  curve(v => 3 * p22(v / 1.25 - 2), 0, 5, stroke: 1.5pt + accent)
  curve(v => 3 * p12(v / 1.25 - 2), 0, 5, stroke: 1.5pt + ink)
  content((5.1, 3 * p22(2) - 0.3), small(fill: accent)[$p_(22)$: stormy stays], anchor: "east")
  content((5.1, 3 * p12(2) + 0.3), small(fill: ink)[$p_(12)$: settled to stormy], anchor: "east")
  content((-0.15, 3), small[1], anchor: "east")
  for x in (-2, 0, 2) { content((x-to-plot(x), -0.35), small[#x]) }
})

#let sketch-equilibrium = cetz.canvas(length: 0.9cm, {
  import cetz.draw: *
  axes(5.4, 3.4, ylabel: small[$pi_"stormy" (x)$])
  content((2.5, -0.75), small[Niño 3.4, $x$ (°C)])
  curve(v => 3 * pi-stormy(v / 1.25 - 2), 0, 5, stroke: 1.5pt + ink)
  for x in (-1, 0, 1) {
    let px = x-to-plot(x)
    let py = 3 * pi-stormy(x)
    line((px, 0), (px, py), stroke: (dash: "dashed", paint: faint))
    circle((px, py), radius: 0.07, fill: accent, stroke: none)
    content((px, -0.35), small[#x])
  }
  content((-0.15, 3), small[1], anchor: "east")
})

// The generator: the climate model supplies the index, the record supplies the weather in each state.
#let sketch-generator = diagram(
  node-stroke: 1pt + ink,
  node-inset: 6pt,
  spacing: (1.6em, 2.4em),
  node((0, 0), small[climate model \ $X_t$], corner-radius: 3pt),
  node((1, 0), small[transitions \ $A(X_t)$], corner-radius: 3pt),
  node((2, 0), small[states \ $S_1, S_2, dots$], corner-radius: 3pt),
  node((3, 0), small[synthetic \ weather $y_t$], corner-radius: 3pt),
  node((4, 0), small[reservoir, \ crop, levee model], corner-radius: 3pt),
  node((2, 1), small[observed days \ in each state, $f_k$], corner-radius: 3pt, stroke: 1pt + accent),
  edge((0, 0), (1, 0), "-|>"),
  edge((1, 0), (2, 0), "-|>"),
  edge((2, 0), (3, 0), "-|>"),
  edge((3, 0), (4, 0), "-|>"),
  edge((2, 1), (3, 0), "-|>", stroke: accent),
)
