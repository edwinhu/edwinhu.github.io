// Shared helpers for website + CV
// No --features html dependency — works for both PDF and HTML targets

// Include a file with heading levels offset by `offset`
#let include-offset(path, offset) = {
  set heading(offset: offset)
  include path
}

// Small caps — Typst renders this correctly in both PDF (native) and
// HTML (inline style: font-variant-caps: small-caps)
#let sc(body) = smallcaps(body)

// Icons (used in contact.typ) — emoji works in both targets
#let email-icon = emoji.mail
#let web-icon = emoji.globe.meridian

// HTML-safe data table — renders as HTML <table> for web, Typst table for PDF
// headers: array of strings, rows: array of arrays
#let data-table(headers, rows) = context {
  if target() == "html" {
    html.elem("table", attrs: (border: "2", cellspacing: "0", cellpadding: "6", rules: "groups", frame: "hsides"), {
      html.elem("thead", {
        html.elem("tr", {
          for h in headers {
            html.elem("th", h)
          }
        })
      })
      html.elem("tbody", {
        for row in rows {
          html.elem("tr", {
            for cell in row {
              html.elem("td", cell)
            }
          })
        }
      })
    })
  } else {
    table(
      columns: headers.len(),
      stroke: 0.5pt,
      align: center,
      ..headers.map(h => strong(h)),
      ..rows.flatten(),
    )
  }
}
