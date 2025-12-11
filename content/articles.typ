#import "/lib/main.typ" as lib

#show: lib.page.with()

#let link_ = link
#let link(dest, body) = {
  let dest = dest.trim(".typ") + ".html"
  link_(dest, body)
}

#{
  let content = read("articles/index.txt")

  for article in content.split() {
    let article_path = "articles/" + article
    import article_path as article

    let title-content = lib.title-content(article.title)

    // TODO: this generate a lot of space between the title and the description
    // in the final html page. figure out how to avoid that.
    html.h3(link(article_path, title-content))
    article.description
  }
}
