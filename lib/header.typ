#let header-setting-element(legend, content) = [
  #html.div(style: "min-width: max-content; text-align: center")[
    #html.fieldset[
      #html.legend(legend)
      #html.div(style: "text-align: justify", content)
    ]
  ]
]

#let radio(id: none, name: none, content) = [
  #html.div[
    #html.input(type: "radio", name: name, id: id)
    // TODO: can't use `label(for: "id")` because `for` is a keyword. It seems
    // It seems like there is no equivalent of `r#for` in typst :(
    //
    // We have to resort to this HORRIBLE solution.
    // https://github.com/typst/typst/issues/7480
    #html.label(..("for": id), content)
  ]
]

#let make(additional-header) = [
  #html.h1[S🦀sha's blog]

  Some thoughts about my computer science journey.

  #html.div(style: "display:flex;justify-content:center;align-items:center; flex-wrap: wrap")[
    #header-setting-element([Theme])[
      #radio(id: "dark-theme-radio", name: "theme")[🌒 Dark theme]
      #radio(id: "system-theme-radio", name: "theme")[💻 System theme]
      #radio(id: "light-theme-radio", name: "theme")[☀️ Light theme]

      #html.div[
        #html.input(type: "checkbox", id: "bw-toggle")
        // TODO: can't use `label(for: "bw-toggle")` because `for` is a keyword. It
        // seems like there is no equivalent of `r#for` in typst :(
        //
        // We have to resort to this HORRIBLE solution.
        // https://github.com/typst/typst/issues/7480
        #html.label(..("for": "bw-toggle"))[🖨 True B&W]
      ]
    ]
    #additional-header
    #html.div(style: "min-width: max-content")[
      #html.fieldset(style: "margin: 5px")[
        #html.legend[Personalization]
        #html.div[
          #html.input(type: "checkbox", id: "cat-toggle")
          // TODO: can't use `label(for: "cat-toggle")` because `for` is a keyword. It
          // seems like there is no equivalent of `r#for` in typst :(
          //
          // We have to resort to this HORRIBLE solution.
          // https://github.com/typst/typst/issues/7480
          #html.label(..("for": "cat-toggle"))[🐱 Cat mode]
        ]]]
  ]
]
