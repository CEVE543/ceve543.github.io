// Quarto template partial for the ceve543 lecture decks. Wraps the vendored
// Dossgollin Lab Touying theme (_typst/slides/theme.typ): `##` headings become
// slides, `#` headings are sections. Wired per-deck via template-partials in
// each deck's frontmatter.

#import "../../_typst/slides/theme.typ": *
#import "../../_typst/slides/colors.typ": rice-warm

// Title background: aerial of a Houston neighborhood flooded by Hurricane
// Harvey (public domain). The theme darkens it with its own 15% scrim behind
// the title text.
#let ceve543-title-background = image(
  "../../_typst/slides/title-bg.jpg", width: 100%, height: 100%, fit: "cover",
)

// Quarto's pandoc output defines `Skylighting`, the function every highlighted
// code cell and every printed result passes through; there is no `raw` element
// to restyle. Its hardcoded #f1f3f5 fill sits a percent off the F4F4F4 slide
// and reads as no box at all projected, and its line numbers sit in a fixed
// 24pt box. Shadow it here, after the generated definition, so a code cell
// gets a tinted panel with a rule down the left. Code is set below body size
// so a long line has more room before it runs off the slide, and an over-long
// line wraps inside the panel. Line numbers come from `code-line-numbers` in a
// deck's frontmatter, which pandoc passes through as `number`; a block of
// printed output never carries it and so stays unnumbered.
#let Skylighting(fill: none, number: false, start: 1, sourcelines) = {
  let numbered = sourcelines.enumerate().map(((i, ln)) => if number {
    box(width: 1.8em, align(right, text(fill: rice-warm.text-muted, str(start + i))))
    h(0.7em)
    ln
  } else { ln })
  block(
    fill: rice-warm.primary.lighten(93%),
    stroke: (left: 3pt + rice-warm.primary),
    width: 100%,
    inset: (x: 10pt, y: 8pt),
    radius: 2pt,
    text(size: 16pt, numbered.join(linebreak())),
  )
}

#let ceve543-slides(
  title: none,
  subtitle: none,
  date: none,
  body,
) = {
  // Citations render inline; the bibliography list itself never prints, the
  // same convention as the source theme's decks.
  show bibliography: none
  // Author-year citations. Typst's default is numeric, which prints "[1]" on a
  // slide whose bibliography never renders, so the number names nothing. The
  // style is Typst's bundled copy of the same one the website uses; Quarto's
  // own `csl:` option cannot be pointed at the file because it escapes the
  // relative path before Typst sees it.
  set bibliography(style: "american-geophysical-union")
  // A slide caption says where the figure came from, and nothing a student
  // has to read from the back of the room. It carries no number, because a
  // deck has no cross references, and it is set smaller and muted so it
  // recedes behind the figure. The theme's own `caption-text` is 10pt, which
  // is sized for a printed page and reads as too small projected, so the size
  // is set here and only the muted colour is taken from the theme.
  set figure(numbering: none)
  show figure.caption: it => context {
    text(size: 14pt, fill: _color-theme.get().text-muted)[#it.body]
  }
  // Quarto writes a markdown pipe table as a plain `#table()`, which takes
  // Typst's default full grid of hairlines and reads as a spreadsheet when
  // projected. Restyle it the way `dgl-table` styles a hand-written table:
  // filled header row, banded body rows, horizontal rules only. Table text is
  // set below body size because a table is read in a glance, not from prose.
  set table(
    inset: (x: 8pt, y: 6pt),
    fill: (_, y) => {
      if y == 0 { rice-warm.emphasis } else if calc.even(y) { rice-warm.emphasis.lighten(94%) } else { rice-warm.surface.lighten(50%) }
    },
    stroke: (x: none, y: 0.6pt + rice-warm.text-muted.lighten(40%)),
  )
  show table: set text(size: 18pt)
  show table.cell.where(y: 0): set text(fill: white, weight: "bold")

  // The vendored theme defaults section slides off, which drops every `#`
  // heading silently. Turning it on gives each one an outline slide.
  show: dgl-theme.with(color-theme: rice-warm, section-outline: true)
  dgl-title-slide(
    title: title,
    author: [James Doss-Gollin],
    institution: subtitle,
    date: date,
    background-image: ceve543-title-background,
  )
  body
}
