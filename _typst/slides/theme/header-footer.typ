// =============================================================================
// Custom Header
// =============================================================================

#import "@preview/touying:0.6.1": *
#import "_state.typ": _color-theme, _fg-on, appendix-max-slide

#let dgl-header(self) = {
  let slide-title = utils.display-current-heading(level: 2)
  if slide-title != none {
    context {
      let ct = _color-theme.get()
      block(
        width: 100%,
        fill: ct.primary,
        inset: (x: 1em, y: 1em),
        outset: (top: 2pt),
      )[
        #text(
          size: 34pt,
          font: "Bebas Neue",
          weight: "bold",
          fill: _fg-on(ct.primary),
        )[#slide-title]
      ]
    }
  }
}

// =============================================================================
// Custom Footer
// =============================================================================

#let dgl-footer(self) = {
  let author = self.info.author
  let short-date = if self.info.date != none {
    if type(self.info.date) == datetime {
      self.info.date.display("[year]")
    } else {
      self.info.date
    }
  } else {
    ""
  }

  context {
    let ct = _color-theme.get()
    set text(size: 12pt, fill: _fg-on(ct.primary))

    align(bottom + left, stack(
      spacing: 0pt,
      // Progress bar
      {
        let current = utils.slide-counter.at(here()).first()
        let appendix-start = appendix-max-slide.final()
        let total-main = if appendix-start != none {
          appendix-start.first()
        } else {
          counter(page).final().first()
        }
        let progress-pct = if total-main > 0 {
          if appendix-start != none and current > appendix-start.first() {
            100%
          } else {
            calc.min(100%, 100% * current / total-main)
          }
        } else {
          0%
        }

        block(
          width: 100%,
          height: 3pt,
          spacing: 0pt,
          outset: 0pt,
          inset: 0pt,
        )[
          #place(left + top)[
            #rect(
              width: 100%,
              height: 3pt,
              fill: ct.accent.transparentize(70%),
              stroke: none,
            )
          ]
          #place(left + top)[
            #rect(
              width: progress-pct,
              height: 3pt,
              fill: ct.accent,
              stroke: none,
            )
          ]
        ]
      },
      // Footer bar
      block(
        width: 100%,
        fill: ct.primary,
        inset: (x: 1em, y: 0.35em),
      )[
        #{
          let current = utils.slide-counter.at(here()).first()
          let appendix-start = appendix-max-slide.final()
          let page-num = if appendix-start != none and current > appendix-start.first() {
            let appendix-num = current - appendix-start.first()
            "A" + str(appendix-num)
          } else {
            utils.slide-counter.display()
          }

          grid(
            columns: (1fr, 1fr, 1fr),
            align: (left, center, right),
            [#author], [#short-date], [#page-num],
          )
        }
      ],
    ))
  }
}
