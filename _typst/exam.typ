// Exam macros shared by the Test 1 pages. Pulled in through
// `include-in-header`, so it lives outside assessments/, which ships
// only .qmd files.

// No page number on the first page.
#set page(footer: context {
  if counter(page).get().first() > 1 [
    #align(center, counter(page).display())
  ]
})

// Keep every table on one page.
#show table: it => block(breakable: false, it)

// A bubble to fill in.
#let bubble = box(baseline: 1pt, circle(radius: 4pt, stroke: 0.5pt + black))

// A multiple-choice option with a bubble to fill in.
#let choice(label, body) = block(above: 0.6em, below: 0.6em, inset: (left: 1em),
  grid(columns: (auto, 1fr), column-gutter: 6pt,
    [#bubble #h(3pt) #text(weight: "bold", label + ".")], body))

// A check-all-that-apply option with a square box to mark.
#let checkbox = box(baseline: 1pt, rect(width: 8pt, height: 8pt, stroke: 0.5pt + black))
#let check(label, body) = block(above: 0.6em, below: 0.6em, inset: (left: 1em),
  grid(columns: (auto, 1fr), column-gutter: 6pt,
    [#checkbox #h(3pt) #text(weight: "bold", label + ".")], body))

// A true/false statement: fill in T or F. The label column has a fixed width,
// so the bubbles line up whether the label is (i) or (iii).
#let tf(label, body) = block(above: 0.8em, below: 0.8em, inset: (left: 1em),
  grid(columns: (2.2em, auto, 1fr), column-gutter: 8pt,
    align(right, text(weight: "bold", "(" + label + ")")),
    [#bubble #h(2pt) *T* #h(6pt) #bubble #h(2pt) *F*], body))

// A box for a written answer, placed right after the part it answers.
#let answerbox(height) = block(above: 0.5em, below: 1.2em, breakable: false,
  rect(width: 100%, height: height, stroke: 0.5pt + black))
