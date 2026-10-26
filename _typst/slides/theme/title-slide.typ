// =============================================================================
// Custom Title Slide
// =============================================================================

#import "@preview/touying:0.6.1": *
#import "_state.typ": _color-theme, _fg-on

#let dgl-title-slide(
  title: none,
  title-line-two: none,
  author: none,
  position: none,
  institution: none,
  date: none,
  venue: none,
  location: none,
  background-image: none,
) = {
  touying-slide-wrapper(self => {
    let self = utils.merge-dicts(
      self,
      config-page(
        fill: none,
        margin: (top: 0pt, bottom: 0pt, left: 0pt, right: 0pt),
        header: none,
        footer: none,
      ),
    )
    self.appendix = true

    touying-slide(
      self: self,
      repeat: 1,
      config: (:),
      setting: body => context {
        let ct = _color-theme.get()

        // Gradient background from emphasis color
        place(top + left)[
          #rect(
            width: 100%,
            height: 100%,
            fill: gradient.linear(
              ct.emphasis,
              ct.emphasis.lighten(20%),
              ct.emphasis.lighten(10%),
              angle: 135deg,
            ),
            stroke: none,
          )
        ]

        // Optional background image with dark overlay
        if background-image != none {
          place(top + left)[
            // Accept a path string (resolved relative to THIS file) or a
            // pre-built image element (resolved by the caller). The latter
            // lets a presentation reference its own figures/ directory.
            #if type(background-image) == str {
              image(background-image, width: 100%, height: 100%, fit: "cover")
            } else {
              box(width: 100%, height: 100%, clip: true, background-image)
            }
          ]
          place(top + left)[
            #rect(width: 100%, height: 100%, fill: black.transparentize(85%), stroke: none)
          ]
        }

        // Content - left aligned
        place(top + left, dx: 1.5em, dy: 3em)[
          #stack(
            spacing: 0pt,
            // Title with highlight
            {
              if title != none or title-line-two != none {
                set text(
                  fill: white,
                  size: 44pt,
                  weight: "bold",
                  font: "Bebas Neue",
                )
                set highlight(fill: ct.primary, extent: 3pt)
                block(width: 75%, upper(if title != none and title-line-two != none {
                  highlight[#title #title-line-two]
                } else if title != none {
                  highlight(title)
                } else {
                  highlight(title-line-two)
                }))
              }
            },
            v(1.75em),

            // Author block
            stack(
              spacing: 3pt,
              if author != none {
                box(fill: ct.emphasis, inset: (x: 10pt, y: 8pt))[
                  #text(fill: _fg-on(ct.emphasis), size: 22pt, weight: "bold")[#author]
                ]
              },
            ),

            v(0.8em),

            // Affiliation block
            stack(
              spacing: 3pt,
              if position != none {
                box(fill: ct.accent2, inset: (x: 10pt, y: 8pt))[
                  #text(fill: _fg-on(ct.accent2), size: 19pt)[#position]
                ]
              },
              if institution != none {
                box(fill: ct.accent2, inset: (x: 10pt, y: 8pt))[
                  #text(fill: _fg-on(ct.accent2), size: 19pt)[#institution]
                ]
              },
            ),

            v(1.5em),

            // Date/venue block
            stack(
              spacing: 3pt,
              if date != none {
                box(fill: ct.accent, inset: (x: 10pt, y: 8pt))[
                  #text(fill: _fg-on(ct.accent), size: 19pt)[
                    #if type(date) == datetime {
                      date.display("[month repr:long] [day], [year]")
                    } else {
                      date
                    }
                  ]
                ]
              },
              if venue != none {
                box(fill: ct.accent, inset: (x: 10pt, y: 8pt))[
                  #text(fill: _fg-on(ct.accent), size: 19pt)[#venue]
                ]
              },
              if location != none {
                box(fill: ct.accent, inset: (x: 10pt, y: 8pt))[
                  #text(fill: _fg-on(ct.accent), size: 19pt)[#location]
                ]
              },
            ),
          )
        ]

        body
      },
    )[]
  })
}
