// Page setup for every course document that renders to PDF: the syllabus, the
// schedule, and the practice problems. The lecture decks are not included;
// they have their own theme in _typst/slides.
//
// Rules here run before Quarto's own template, so this file holds only what
// the template does not set afterward. Anything the template overrides,
// paragraph settings in particular, belongs in document-body.typ instead.
//
// See document-body.typ for the frontmatter a document needs to use both.

// Fira Sans sets long words solid; hyphenation only produces ragged breaks
// like "Hydrocli-mate" in the title.
#set text(hyphenate: false)
#show raw: set text(font: "Fira Mono")
#show math.equation: set text(font: "STIX Two Math")

// This has to run from the header block. A `set page` rule reached in the body
// starts a new page, which strands the floated title block on a page of its
// own.
//
// Margins are not set here. Quarto's template applies its own `margin:` after
// this file runs, so a page rule here would be overridden; each document sets
// margins in its own frontmatter instead.
// Author-year citations. Typst's default is numeric, and Quarto's `csl:` option
// cannot be pointed at the repo's CSL file: it escapes the relative path before
// Typst sees it. This is Typst's bundled copy of the style the website uses.
#set bibliography(style: "american-geophysical-union")

#set page(footer: context [
  #set text(size: 8pt, fill: rgb("#7C7E7F"))
  CEVE 543 | Fall 2026
  #h(1fr)
  #counter(page).display()
])
