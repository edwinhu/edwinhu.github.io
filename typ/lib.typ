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
