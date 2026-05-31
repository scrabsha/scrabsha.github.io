#import "/lib/main.typ" as lib
#import "/lib/articles.typ" as articles

#show: lib.page.with()

#let link_ = link
#let link(dest, body) = {
  let dest = dest.trim(".typ") + ".html"
  link_(dest, body)
}

#{
  let articles = articles.articles

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
