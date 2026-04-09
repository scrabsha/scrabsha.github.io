#import "/lib/main.typ" as lib

#show: lib.page.with()

#let link_ = link
#let link(dest, body) = {
  let dest = dest.trim(".typ") + ".html"
  link_(dest, body)
}

#{
  let content = read("articles/index.txt")

  let articles = content
    .split()
    .map(article => {
      let path = "articles/" + article
      import path as article
      (path, article)
    })
    .sorted(key: article => article.at(1).published-date)
    .rev()

  for article in articles {
    let path = article.at(0)
    let mod = article.at(1)
    let title-content = lib.title-content(mod.title)

    // TODO: this generate a lot of space between the title and the description
    // in the final html page. figure out how to avoid that.
    html.h3(link(path, title-content))
    dictionary(mod).at("description", default: [])
  }
}
