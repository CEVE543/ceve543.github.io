// =============================================================================
// Section Slide, Focus Slide, Focus List
// =============================================================================

#import "@preview/touying:0.6.1": *
#import "_state.typ": _color-theme, _fg-on

#let section-slide(title) = context {
  let ct = _color-theme.get()
  align(center + horizon)[
    #text(size: 22pt, weight: "bold", fill: ct.emphasis, font: "Bebas Neue")[#title]
  ]
}

#let dgl-focus-slide(body) = context {
  let ct = _color-theme.get()
  set page(fill: ct.emphasis)
  align(center + horizon)[
    #text(fill: _fg-on(ct.emphasis), size: 24pt)[#body]
  ]
}

// =============================================================================
// Outline Slide - Auto-generated section progress indicator
// =============================================================================
// Shows all level-1 headings, highlighting the current section.
// Use as new-section-slide-fn in dgl-theme to auto-generate on each = heading.
//
// Usage (automatic, via theme config):
//   #show: dgl-theme.with(color-theme: roma, section-outline: true)
//
// Usage (manual):
//   #section-outline-slide[ignored]

#let section-outline-slide(
  body,
  active-color: auto,
  dim-color: auto,
) = touying-slide-wrapper(self => {
  // Use Touying's config-colors (primary = emphasis, set in dgl-theme)
  let bg = self.colors.primary

  let self = utils.merge-dicts(
    self,
    config-page(
      fill: bg,
      margin: (top: 0pt, bottom: 0pt, left: 0pt, right: 0pt),
      header: none,
      footer: none,
    ),
  )

  // Get current section from Touying's heading tracking
  let current-heading-body = {
    let h1s = self.headings.filter(h => h.depth == 1)
    if h1s.len() > 0 { h1s.last().body } else { none }
  }

  touying-slide(
    self: self,
    repeat: 1,
    config: (:),
    setting: body => {
      context {
        let ct = _color-theme.get()
        let ac = if active-color == auto { ct.accent } else { active-color }
        let dc = if dim-color == auto { ct.surface.transparentize(50%) } else { dim-color }
        let all-sections = query(heading.where(level: 1))

        align(
          left + horizon,
          pad(
            left: 15%,
            right: 15%,
            stack(
              spacing: 1.25em,
              ..all-sections.map(section => {
                let is-active = section.body == current-heading-body
                if is-active {
                  text(fill: ac, weight: "bold", size: 28pt)[#section.body]
                } else {
                  text(fill: dc, weight: "regular", size: 28pt)[#section.body]
                }
              }),
            ),
          ),
        )
      }

      body
    },
  )[]
})

// =============================================================================
// Utility: Dummy Frame Title
// =============================================================================

#let dummy-frame-title(title) = context {
  let ct = _color-theme.get()
  text(size: 14pt, weight: "bold", fill: ct.emphasis)[#title]
}

// =============================================================================
// Focus List - Auto-cycling highlight through list items
// =============================================================================
// Each item is highlighted on its corresponding subslide, others are dimmed.
// Automatically creates N+1 subslides: one per item focused, plus a final
// subslide with all items shown active.
//
// Usage:
//   #focus-list(([First point], [Second point], [Third point]))

#let focus-list(
  items,
  active-color: auto,
  dim-color: auto,
) = {
  // NOTE: alternatives() cannot be inside a `context` block (Touying limitation).
  // Instead, each alternative's content uses `context` internally to read theme colors.
  let render-list(active-index) = context {
    let ct = _color-theme.get()
    let ac = if active-color == auto { ct.primary } else { active-color }
    let dc = if dim-color == auto { ct.text-muted.transparentize(50%) } else { dim-color }
    for (index, item) in items.enumerate() {
      let is-active = index == active-index
      let color = if is-active { ac } else { dc }
      let weight = if is-active { "bold" } else { "regular" }
      set text(fill: color, weight: weight)
      enum(start: index + 1, item)
    }
  }

  // Final subslide: all items shown active (not bold)
  let render-all() = context {
    let ct = _color-theme.get()
    let ac = if active-color == auto { ct.primary } else { active-color }
    for (index, item) in items.enumerate() {
      set text(fill: ac, weight: "regular")
      enum(start: index + 1, item)
    }
  }

  alternatives(
    ..range(items.len()).map(i => render-list(i)),
    render-all(),
  )
}
