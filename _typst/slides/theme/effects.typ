// =============================================================================
// Shadow and Polaroid effects
// =============================================================================

#import "@preview/cetz:0.4.2"
#import "@preview/shadowed:0.2.0": shadowed as pkg-shadow
#import "_state.typ": _color-theme, default-shadow-direction, default-shadow-offset, default-shadow-blur, default-shadow-color

// =============================================================================
// Shadow Helper
// =============================================================================

#let shadow(
  content,
  direction: default-shadow-direction,
  offset: default-shadow-offset,
  blur: default-shadow-blur,
  color: default-shadow-color,
) = {
  let (dx, dy) = if direction == "bottom-right" {
    (offset, offset)
  } else if direction == "bottom-left" {
    (-offset, offset)
  } else if direction == "top-right" {
    (offset, -offset)
  } else if direction == "top-left" {
    (-offset, -offset)
  } else {
    (offset, offset)
  }

  pkg-shadow(shadow: blur, color: color, dx: dx, dy: dy)[#content]
}

// =============================================================================
// Shared Helpers for Polaroid
// =============================================================================

#let compute-auto-tilt(seed-content) = {
  if seed-content != none {
    (calc.rem(repr(seed-content).len(), 7) - 3) * 1deg
  } else {
    2deg
  }
}

#let apply-tilt-and-shadow(content, angle, show-shadow) = {
  let with-shadow = if show-shadow { shadow(content) } else { content }
  rotate(angle, with-shadow)
}

// =============================================================================
// Polaroid - Vintage instant photo frame effect
// =============================================================================

#let polaroid(
  body,
  width: 40%,
  caption: none,
  tilt: auto,
  show-shadow: true,
  border-width: 8pt,
  bottom-height: 32pt,
  caption-spacing: 6pt,
) = context {
  let ct = _color-theme.get()
  let angle = if tilt == auto { compute-auto-tilt(caption) } else { tilt }

  let polaroid-content = box(
    width: width,
    fill: white,
    stroke: 0.5pt + luma(200),
    inset: (
      top: border-width,
      left: border-width,
      right: border-width,
      bottom: bottom-height,
    ),
    {
      box(width: 100%, body)
      if caption != none {
        v(caption-spacing)
        align(center, box(width: 100%, text(size: 11pt, fill: ct.text-muted)[#caption]))
      }
    },
  )

  apply-tilt-and-shadow(polaroid-content, angle, show-shadow)
}
