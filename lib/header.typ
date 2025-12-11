#html.h1[S🦀sha's blog]

Some thoughts about my computer science journey.

#html.div(style: "position: centered")[
  #html.div[
    #html.input(type: "checkbox", id: "cat-toggle")
    // TODO: can't use `label(for: "cat-toggle")` because `for` is a keyword. It
    // seems like there is no equivalent of `r#for` in typst :(
    //
    // We have to resort to this HORRIBLE solution.
    // https://github.com/typst/typst/issues/7480
    #html.label(..("for": "cat-toggle"))[Cat mode 🐱]
  ]

  #html.div[
    #html.input(type: "checkbox", id: "dark-theme-toggle")
    // TODO: can't use `label(for: "cat-toggle")` because `for` is a keyword. It
    // seems like there is no equivalent of `r#for` in typst :(
    //
    // We have to resort to this HORRIBLE solution.
    // https://github.com/typst/typst/issues/7480
    #html.label(..("for": "dark-theme-toggle"))[Dark theme 🌒]
  ]
]
