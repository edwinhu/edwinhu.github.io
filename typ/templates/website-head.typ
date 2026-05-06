// HTML website template with custom <head>
// base: path prefix for assets (e.g., ".." for subpages like software/)
#let website-page(title: "Edwin Hu", base: ".", body) = context {
  if target() == "html" {
    html.elem("html", attrs: (lang: "en"), {
      html.elem("head", {
        html.elem("meta", attrs: (charset: "utf-8"))
        html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1"))
        html.elem("title", title)
        html.elem("meta", attrs: (name: "author", content: "Edwin Hu"))
        // CSS
        html.elem("link", attrs: (rel: "stylesheet", href: base + "/css/latex.css"))
        html.elem("style", "@font-face{font-family:'New Computer Modern';font-style:normal;font-weight:normal;font-display:swap;src:url('" + base + "/css/fonts/NewCM10-Regular.woff2') format('woff2')}@font-face{font-family:'New Computer Modern';font-style:italic;font-weight:normal;font-display:swap;src:url('" + base + "/css/fonts/NewCM10-Italic.woff2') format('woff2')}@font-face{font-family:'New Computer Modern';font-style:normal;font-weight:bold;font-display:swap;src:url('" + base + "/css/fonts/NewCM10-Bold.woff2') format('woff2')}@font-face{font-family:'New Computer Modern';font-style:italic;font-weight:bold;font-display:swap;src:url('" + base + "/css/fonts/NewCM10-BoldItalic.woff2') format('woff2')}body{max-width:60em!important;margin:auto;font-family:'New Computer Modern','Latin Modern',Georgia,Cambria,'Times New Roman',Times,serif}.smallcaps{font-variant:small-caps}h1{font-variant:small-caps}nav[role=doc-toc] li>div{display:inline}nav[role=doc-toc] ol{padding-left:1.5em}nav[role=doc-toc]>ol{padding-left:0}a{color:#232D4B}a:visited{color:#232D4B}")
        // Favicon
        html.elem("link", attrs: (rel: "icon", href: base + "/favicon.ico", type: "image/x-icon"))
        // Google Analytics
        html.elem("script", attrs: (async: "", src: "https://www.googletagmanager.com/gtag/js?id=UA-67919104-1"))
        html.elem("script", "window.dataLayer=window.dataLayer||[];function gtag(){dataLayer.push(arguments)}gtag('js',new Date());gtag('config','UA-67919104-1');")
      })
      html.elem("body", body)
    })
  } else {
    body
  }
}
