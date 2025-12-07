#let page(
  title: "",
  body,
) = {
  html.html(
    lang: "en",
    {
      html.head({
        html.meta(charset: "utf-8")
        html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
        html.link(rel: "stylesheet", href: "/stylesheet.css")
        html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
        html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")
        html.link(
          rel: "stylesheet",
          href: "https://fonts.googleapis.com/css2?family=Libertinus+Serif:ital,wght@0,400;0,600;0,700;1,400;1,600;1,700&display=swap",
        )

        if title != "" {
          html.meta(title: title)
        }
      })
      
      set raw(theme: "../style/typst-gruvy-dark.tmTheme")
      html.body({
        html.header({
          include "header.typ"
        })
        body
      })
    },
  )
}
