// Typography for every course document that renders to PDF. Pairs with
// document-header.typ, which holds the page setup; see that file for why the
// styling is split across two includes.
//
// To use both, a document's typst format block needs:
//
//   font-paths:
//     - _typst/fonts                 # path relative to the document
//   mainfont: "Fira Sans"
//   fontsize: 10.5pt
//   include-in-header:
//     - _typst/document-header.typ
//   include-before-body:
//     - _typst/document-body.typ
//
// Headings pick up Space Grotesk from the show rule below. The title block is
// not a `heading` element, so a show rule cannot reach it; a document with a
// title that should match adds a brand block at the top level of its
// frontmatter, as syllabus.qmd does:
//
//   brand:
//     typography:
//       headings:
//         family: "Space Grotesk"
//
// That key only works in a document's own frontmatter. Quarto's schema
// rejects a brand block in a directory `_metadata.yml`.

// The rice-warm palette from _typst/slides/colors.typ, so the printed
// handouts, the website, and the lecture decks match. Spelled out rather than
// imported because Quarto injects this file as raw text into its own template,
// where a relative `#import` does not resolve.
#let rice-blue = rgb("#00205B")
#let rice-midnight = rgb("#13133E")
#let rice-gold = rgb("#E9A139")
#let rice-link = rgb("#0A509E")
#let rule-gray = rgb("#C8C8C8")

// Ragged right. Justified setting opens uneven word spacing at this measure,
// and the effect is worse in a sans face. Quarto's template sets justify on,
// so this has to run after it, which is why it is here and not in the header.
#set par(justify: false, leading: 0.8em, spacing: 1.15em)

#show heading: set text(font: "Space Grotesk")
#show link: set text(fill: rice-link)

// Tables are usually dense reference material, so they read a step smaller
// than the body, with a colored rule under the header row.
#show table: set text(size: 9.5pt)
#show table.cell.where(y: 0): strong
#set table(
  stroke: (x, y) => (
    bottom: if y == 0 { 0.6pt + rice-blue } else { 0.2pt + rule-gray },
  ),
  inset: (x: 0.4em, y: 0.5em),
)

// The gold rule under each top-level heading is the one piece of decoration.
// It gives a long handout visible section boundaries when skimmed.
#show heading.where(level: 1): it => block(above: 1.6em, below: 0.9em)[
  #text(fill: rice-blue, size: 1.3em, it.body)
  #v(-0.55em)
  #line(length: 100%, stroke: 0.5pt + rice-gold)
]
#show heading.where(level: 2): set text(fill: rice-blue)
#show heading.where(level: 3): set text(fill: rice-midnight)
