// =============================================================================
// Dossgollin Lab Theme for Touying
// A parameterized presentation theme with swappable color palettes
// =============================================================================
//
// FONT SIZE REFERENCE (LaTeX at 10pt base, with Bebas Neue 1.3x scale)
// -----------------------------------------------------------------------------
// LaTeX Size     | Base pt | x1.3 (Bebas) | Typst Usage
// -----------------------------------------------------------------------------
// \tiny          |   5pt   |     -        | Bullets (5pt gold squares)
// \scriptsize    |   7pt   |     -        | -
// \footnotesize  |   8pt   |     -        | Figure captions (8pt SlateGrey)
// \small         |   9pt   |     -        | Footer text (9pt MarbleWhite)
// \normalsize    |  10pt   |    13pt      | capfig title (12pt TiberBlue bold)
// \large         |  12pt   |    16pt      | dummyFrameTitle (14pt TiberBlue bold)
// \Large         |  14pt   |    19pt      | [UPDATED: see below]
// \LARGE         |  17pt   |    22pt      | Section slide (22pt Bebas TiberBlue)
// \huge          |  21pt   |    27pt      | Title slide (27pt Bebas white)
// \Huge          |  25pt   |    32pt      | Frame titles (34pt Bebas MarbleWhite)
// -----------------------------------------------------------------------------
// Body text: 22pt Fira Sans light (larger than LaTeX for projection)
// Title slide metadata: 19-22pt (author bold, position/date regular)
// Frame titles: 34pt (increased from 19pt for better prominence and visibility)
// =============================================================================

#import "@preview/touying:0.6.1": *
#import "colors.typ": roma

// Re-export all sub-modules
#import "theme/_state.typ": *
#import "theme/callouts.typ": *
#import "theme/figures.typ": *
#import "theme/text.typ": *
#import "theme/header-footer.typ": *
#import "theme/title-slide.typ": *
#import "theme/slides.typ": *
#import "theme/effects.typ": *
#import "theme/tables.typ": *

// =============================================================================
// Dossgollin Lab Theme Function (combined theme + style)
// =============================================================================
// Sets up Touying slides, typography, and color state in one show rule.
//
// Usage in presentation.typ:
//   #import "colors.typ": roma
//   #show: dgl-theme.with(color-theme: roma, ...)

#let dgl-theme(
  color-theme: roma,
  aspect-ratio: "16-9",
  speaker-notes: none,
  section-outline: false,
  ..args,
  body,
) = {
  // Set color theme state for standalone functions
  _color-theme.update(color-theme)

  // Typography (body text, math, code)
  set text(
    font: "Fira Sans",
    size: 22pt,
    fill: color-theme.text,
  )
  show math.equation: set text(font: "STIX Two Math")
  show raw: set text(font: "Fira Mono")
  set strong(delta: 100)
  // Ragged-right, not justified. Slide columns are narrow, so justification
  // either hyphenates badly ("man-agement", "stationar-ity") or stretches the
  // word spacing into visible rivers. Both read worse at projection size than
  // an uneven right edge.
  set par(justify: false)
  set text(hyphenate: false)
  set list(spacing: 1.2em)
  set enum(numbering: "1.", spacing: 1.2em)
  show heading.where(level: 1): it => none

  // Touying slide framework
  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      fill: color-theme.surface,
      margin: (top: 3.5em, bottom: 2em, left: 2em, right: 2em),
      header-ascent: 20%,
      footer-descent: 15%,
    ),
    config-common(
      slide-level: 2,
      show-strong-with-alert: false,
      show-notes-on-second-screen: speaker-notes,
      ..if section-outline {
        (
          new-section-slide-fn: section-outline-slide,
          receive-body-for-new-section-slide-fn: false,
        )
      },
    ),
    config-methods(
      ..if not section-outline { (touying-new-section-slide: none,) },
      slide: touying-slide-wrapper.with(
        self => {
          touying-slide(
            self: self,
            repeat: auto,
            setting: body => {
              show: align.with(horizon)
              body
            },
            ..args,
          )
        },
      ),
      title-slide: (..targs) => {
        dgl-title-slide(..targs)
      },
      focus-slide: fbody => {
        dgl-focus-slide(fbody)
      },
    ),
    config-colors(
      primary: color-theme.emphasis,
      primary-light: color-theme.surface,
      primary-dark: color-theme.emphasis.darken(20%),
      secondary: color-theme.primary,
      neutral-lightest: color-theme.surface,
      neutral-light: color-theme.text-muted.lighten(60%),
      neutral-dark: color-theme.text,
      neutral-darkest: color-theme.emphasis,
    ),
    config-page(
      header: dgl-header,
      footer: dgl-footer,
    ),
    ..args,
  )

  body
}
