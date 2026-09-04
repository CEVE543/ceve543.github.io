// =============================================================================
// Color Themes for Dossgollin Lab Presentations
// =============================================================================
//
// Each theme is a dictionary with the following semantic color slots:
//
//   primary    Main brand color. Used for slide headers, footers, and the
//              highlighted title box on the title slide.
//
//   emphasis   Structural emphasis color. Used for bold emphasis text (#alert),
//              figure titles, section slide headings, focus slide background,
//              and the title slide gradient. May equal primary.
//
//   accent     High-visibility pop color. Used for inline highlights (#hl),
//              bullet markers, the progress bar, and date/venue boxes on
//              the title slide.
//
//   accent2    Secondary accent for variety. Used for warning callouts and
//              the affiliation boxes on the title slide.
//
//   surface    Slide background fill.
//
//   text       Body text color.
//
//   text-muted Subdued text for captions, citations, and footnotes.
//
// Derived colors (not specified per theme):
//   Callout body backgrounds — header color lightened 85%
//   Borders — text-muted lightened 60%
//   Surface-alt — surface darkened 5%
// =============================================================================

// -----------------------------------------------------------------------------
// Roma — inspired by AS Roma football club
// -----------------------------------------------------------------------------
#let roma = (
  primary:    rgb("#8E1F2F"),  // Rosso Roma
  emphasis:   rgb("#1D2948"),  // Tiber Blue
  accent:     rgb("#F0BC42"),  // Giallo Roma
  accent2:    rgb("#C45824"),  // Tiber Terracotta
  surface:    rgb("#F4F4F4"),  // Marble White
  text:       rgb("#111111"),  // Pitch Black
  text-muted: rgb("#666666"),  // Slate Grey
)

// -----------------------------------------------------------------------------
// Rice Warm — Rice University blue with warm accent colors
// -----------------------------------------------------------------------------
#let rice-warm = (
  primary:    rgb("#00205B"),  // Rice Blue
  emphasis:   rgb("#13133E"),  // Midnight Blue
  accent:     rgb("#E9A139"),  // Warm Yellow
  accent2:    rgb("#C04829"),  // Brick Red
  surface:    rgb("#F4F4F4"),  // Light neutral
  text:       rgb("#111111"),  // Near black
  text-muted: rgb("#7C7E7F"),  // Rice Gray
)

// -----------------------------------------------------------------------------
// Rice Cool — Rice University blue with cool blue accent colors
// -----------------------------------------------------------------------------
#let rice-cool = (
  primary:    rgb("#00205B"),  // Rice Blue
  emphasis:   rgb("#13133E"),  // Midnight Blue
  accent:     rgb("#4D9AD4"),  // Medium Blue
  accent2:    rgb("#0A509E"),  // Rich Blue
  surface:    rgb("#F4F4F4"),  // Light neutral
  text:       rgb("#111111"),  // Near black
  text-muted: rgb("#7C7E7F"),  // Rice Gray
)
