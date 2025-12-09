#let page-title-suffix = "S🦀sha's blog"
#let page-title-separator = " | "

#let paragraph-name(body) = {
  html.span(class: "margin-note", {
    html.span(class: "left-margin-note", body)
  })
}

#let title-ascii(title) = {
  if title == none {
    none
  } else if type(title) == str {
    title
  } else if type(title) == array {
    title.at(0)
  }
}

#let title-content(title) = {
  if title == none {
    none
  } else if type(title) == str {
    [#title]
  } else if type(title) == array {
    title.at(1)
  }
}

#let page(
  title: none,
  date: none,
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

        let title-ascii = title-ascii(title)
        let title = if title-ascii == none {
          page-title-suffix
        } else {
          title-ascii + page-title-separator + page-title-suffix
        }

        html.title(title)
      })

      set raw(theme: "../style/typst-gruvy-dark.tmTheme")
      html.body({
        html.header({
          include "header.typ"
        })
        if title != none {
          let title = title-content(title)
          html.h1(title)
        }
        if date != none {
          html.small[
            Published on #date.display()
          ]
        }
        body
      })
    },
  )
}
