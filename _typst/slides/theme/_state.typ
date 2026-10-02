// =============================================================================
// Color Theme State & Core Helpers
// =============================================================================
// The active color theme is stored as Typst state so that standalone functions
// (callout, alert, hl, etc.) can read the current palette via `context`.
// The theme is set once by `dgl-theme` at the start of the document.

#import "@preview/touying:0.6.1": *
#import "@preview/fontawesome:0.6.0": *
#import "../colors.typ": roma

#let _color-theme = state("dgl-color-theme", roma)

// State to freeze slide counter for appendix slides
#let appendix-max-slide = state("appendix-max-slide", none)

// Function to start appendix (call this before appendix slides)
#let start-appendix() = context {
  appendix-max-slide.update(utils.slide-counter.get())
}

// =============================================================================
// Helper: Readable Foreground Color
// =============================================================================
// Returns dark text for light backgrounds, white text for dark backgrounds.
// Uses perceived brightness formula (ITU-R BT.601).

#let _fg-on(bg) = {
  let c = bg.components()
  let lum = 0.299 * c.at(0) + 0.587 * c.at(1) + 0.114 * c.at(2)
  if lum > 50% { rgb("#111111") } else { white }
}

// =============================================================================
// Global Shadow Configuration
// =============================================================================

#let default-shadow-direction = "bottom-right"
#let default-shadow-offset = 6pt
#let default-shadow-blur = 8pt
#let default-shadow-color = black.transparentize(70%)

// =============================================================================
// Speaker Notes
// =============================================================================

// `target` prints a running-clock cue at the top of the note.
// `verbatim` holds the sentences to actually say; the positional body holds the
// terse bullets to glance at. Both render, verbatim first, so the notes PDF
// works whether you read it through or skim it while presenting.
#let speaker-note-styled(target: none, verbatim: none, body) = speaker-note(text(size: 24pt)[
  #if target != none [
    #text(fill: luma(120), size: 16pt)[#box(baseline: -1pt)[#fa-icon("clock")] #target] \
  ]
  #if verbatim != none [
    #text(style: "italic")[#verbatim]
    #v(0.4em)
  ]
  #body
])
