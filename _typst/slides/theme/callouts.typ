// =============================================================================
// Callout Boxes - Quarto-style with color-coded types
// =============================================================================
// Implements 5 callout types: note, tip, important, warning, caution
// Header backgrounds use theme colors; body backgrounds are per-type
// tuned tints for visual refinement across different color themes.

#import "@preview/fontawesome:0.6.0": *
#import "_state.typ": _color-theme, _fg-on

// `body` is accepted named or positional. Quarto's Typst writer emits every
// callout as `#callout(body: [...], title: ...)`, so a positional-only `body`
// fails any deck holding a Quarto callout div. The boxes below this pass it
// positionally, so both spellings have to work.
#let callout(
  type: "note",
  title: auto,
  icon: auto,
  body: none,
  ..rest,
) = context {
  let body = if body == none { rest.pos().at(0, default: []) } else { body }
  let ct = _color-theme.get()

  // Map callout types to theme color slots
  let type-config = (
    note: (
      header-bg: ct.emphasis,
      body-bg: ct.emphasis.lighten(90%),
      default-icon: fa-icon("circle-info", solid: true),
      default-title: "Note",
    ),
    tip: (
      header-bg: ct.accent,
      body-bg: ct.accent.lighten(85%),
      default-icon: fa-icon("lightbulb", solid: true),
      default-title: "Tip",
    ),
    important: (
      header-bg: ct.primary,
      body-bg: ct.primary.lighten(88%),
      default-icon: fa-icon("key", solid: true),
      default-title: "Important",
    ),
    warning: (
      header-bg: ct.accent2,
      body-bg: ct.accent2.lighten(85%),
      default-icon: fa-icon("triangle-exclamation", solid: true),
      default-title: "Warning",
    ),
    caution: (
      header-bg: ct.text-muted,
      body-bg: luma(240),
      default-icon: fa-icon("circle-exclamation", solid: true),
      default-title: "Caution",
    ),
  )

  let config = type-config.at(type)
  let header-fg = _fg-on(config.header-bg)
  let body-bg = config.body-bg

  // Resolve title
  let resolved-title = if title == auto {
    config.default-title
  } else if title == none {
    none
  } else {
    title
  }

  // Resolve icon
  let resolved-icon = if icon == auto {
    config.default-icon
  } else if icon == none {
    none
  } else {
    icon
  }

  // Render the callout
  block(
    width: 100%,
    stroke: 1pt + config.header-bg,
    fill: body-bg,
    radius: 5pt,
    clip: true,
  )[
    #if resolved-title != none or resolved-icon != none {
      block(
        width: 100%,
        fill: config.header-bg,
        inset: 8pt,
      )[
        #text(fill: header-fg, weight: "bold", size: 18pt)[
          #if resolved-icon != none [#resolved-icon~]
          #if resolved-title != none [#resolved-title]
        ]
      ]
    }
    #block(inset: 8pt, spacing: 0pt)[
      #text(fill: ct.text, size: 18pt)[#body]
    ]
  ]
}

// Backward compatibility aliases
#let questionbox(body) = callout(type: "note", title: "Question", body)
#let takeawaybox(body) = callout(type: "tip", title: "Key Takeaway", body)
#let notebox(body) = callout(type: "note", body)
#let highlightbox(body) = callout(type: "important", title: "Highlight", body)
#let warningbox(body) = callout(type: "warning", body)
