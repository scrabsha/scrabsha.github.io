// Ported from fa-arrow-rotate-left by the font awesome
//
// https://fontawesome.com/icons/arrow-rotate-left?f=classic&s=solid
//
// Font Awesome Free v7.1.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2026 Fonticons, Inc.
#let fa-arrow-rotate-left = html.elem(
  "svg",
  attrs: (
    xmlns: "http://www.w3.org/2000/svg",
    viewBox: "0 0 640 640",
    style: "fill: #496fcc; width: 2rem; margin-left: 0.5rem",
  ),
  html.elem(
    "path",
    attrs: (
      d: "M320 128C263.2 128 212.1 152.7 176.9 192L224 192C241.7 192 256 206.3 256 224C256 241.7 241.7 256 224 256L96 256C78.3 256 64 241.7 64 224L64 96C64 78.3 78.3 64 96 64C113.7 64 128 78.3 128 96L128 150.7C174.9 97.6 243.5 64 320 64C461.4 64 576 178.6 576 320C576 461.4 461.4 576 320 576C233 576 156.1 532.6 109.9 466.3C99.8 451.8 103.3 431.9 117.8 421.7C132.3 411.5 152.2 415.1 162.4 429.6C197.2 479.4 254.8 511.9 320 511.9C426 511.9 512 425.9 512 319.9C512 213.9 426 128 320 128z",
    ),
  ),
)

#let title(string-name, content-name) = {
  let content-name = html.span(style: "display: flex; justify-content: space-between; align-items: center")[
    #html.h1[#content-name]
    #html.div(id: "clear-food-checkboxes", style: "display: flex; align-items: center")[
      #html.a[Clear checkboxes] #[#fa-arrow-rotate-left]
    ]
  ]

  (string-name, content-name)
}

#let page(body) = {
  let food-counter = counter("list-item-id")

  import "meows.typ" as meows

  show list.item: it => context {
    let id = str(food-counter.get().first())
    food-counter.step()
    let id = "list-checkbox-" + id

    let checkbox-class = "food-item-checkbox"

    [
      #html.div(style: "position: relative; display: block")[
        #html.li(style: "list-style: none")[
          #html.input(
            type: "checkbox",
            id: id,
            class: checkbox-class,
            name: id,
            style: "display: inline-block",
            checked: false,
          )
          #html.label(..("for": id))[#meows.meows(density: 8, it.body)]
        ]
      ]
    ]
  }

  html.form(name: "recipe", body)
}

#let item(fr: none, it: none, nl: none, start, amount) = {
  [
    #start
    #html.span(class: "product product-fr")[_#fr _]
    #html.span(class: "product product-it")[_#it _]
    #html.span(class: "product product-nl")[_#nl _]
    (#amount)
  ]
}

#let t45-flour(amount) = {
  // https://www.weekendbakery.com/posts/understanding-flour-types/comment-page-2/
  item(fr: [farine T45], it: [farina tipo 00], nl: [zeeuwse bloem], [Flour], amount)
}

#let fresh-yeast(amount) = {
  item(fr: [levure boulangère], it: [livieto di birra fresca], nl: [verse gist], [Yeast], amount)
}

#let milk(amount) = {
  item(fr: [lait demi-écrémé], it: [latte parzialmente scremato], nl: [halfvolle melk], [Milk], amount)
}

#let header = [
  #let localized-product-name-button(language-name, shortcode) = [
    #let input-id = "product-names-" + shortcode
    #html.div[
      #html.input(
        type: "radio",
        name: "product_language",
        value: shortcode,
        id: input-id,
      )
      #html.label(..("for": input-id), language-name)
    ]
  ]
  #html.div(style: "min-width: max-content")[
    #html.fieldset(style: "margin: 5px; text-align: left")[
      #html.legend[Ingredient language]
      #localized-product-name-button([🇫🇷 French], "fr")
      #localized-product-name-button([🇮🇹 Italian], "it")
      #localized-product-name-button([🇳🇱 Dutch], "nl")
    ]
  ]
]

