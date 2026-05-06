#import "../lib.typ": email-icon, web-icon

#context {
  if target() == "html" {
    html.elem("table", attrs: (border: "2", cellspacing: "0", cellpadding: "6", rules: "groups", frame: "hsides"), {
      html.elem("tbody", {
        html.elem("tr", {
          html.elem("td", [UVA School of Law])
          html.elem("td", [Last Updated: #datetime.today().display("[year]-[month]-[day]")])
        })
        html.elem("tr", {
          html.elem("td", [580 Massie Road])
          html.elem("td", [#email-icon: #raw("ehu@law.virginia.edu")])
        })
        html.elem("tr", {
          html.elem("td", [Charlottesville, VA 22903])
          html.elem("td", [#web-icon: #link("http://edwinhu.github.io")[edwinhu.github.io]])
        })
      })
    })
  } else {
    align(center,
      table(
        columns: 2,
        stroke: none,
        align: left+bottom,
        [UVA School of Law], [Last Updated: #datetime.today().display("[year]-[month]-[day]")],
        [580 Massie Road], [#email-icon: `ehu@law.virginia.edu`],
        [Charlottesville, VA 22903], [#web-icon: #link("http://edwinhu.github.io")[edwinhu.github.io]],
      )
    )
    v(-1em)
  }
}
