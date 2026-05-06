// CV PDF template — matches org_cv.sty formatting
#let cv-template(body) = {
  set document(title: "Edwin Hu", author: "Edwin Hu")
  set page(
    paper: "us-letter",
    numbering: none,
  )
  set text(font: "New Computer Modern")

  // Title: centered, huge, smallcaps, with rule below
  align(center, text(size: 24pt, smallcaps[Edwin Hu]))
  v(-2em)
  line(length: 100%, stroke: 0.4pt)

  // Section headings: large, smallcaps, raggedright, rule below
  show heading.where(level: 1): it => {
    smallcaps(it.body) 
    v(-0.75em)
    line(length: 100%, stroke: 0.4pt)
  }

  // Subsection headings: normalsize, no decoration
  show heading.where(level: 2): it => {
    it.body
  }

  // Compact lists
  set list(indent: 0.5em)

  body
}
