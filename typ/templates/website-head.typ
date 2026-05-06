// HTML website template with custom <head>
#let website-page(title: "Edwin Hu", body) = context {
  if target() == "html" {
    html.elem("html", attrs: (lang: "en"), {
      html.elem("head", {
        html.elem("meta", attrs: (charset: "utf-8"))
        html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1"))
        html.elem("title", title)
        html.elem("meta", attrs: (name: "author", content: "Edwin Hu"))
        // CSS
        html.elem("link", attrs: (rel: "stylesheet", href: "css/latex.css"))
        html.elem("style", "body{max-width:60em!important;margin:auto}.smallcaps{font-variant:small-caps}h1{font-variant:small-caps}nav[role=doc-toc] li>div{display:inline}nav[role=doc-toc] ol{padding-left:1.5em}nav[role=doc-toc]>ol{padding-left:0}a{color:#232D4B}a:visited{color:#232D4B}")
        // Favicon
        html.elem("link", attrs: (rel: "icon", href: "favicon.ico", type: "image/x-icon"))
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
