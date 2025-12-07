#import "/lib/main.typ" as lib

#lib.page(title: "Articles :3")[
  #let link_ = link
  #let link(dest, body) = {
    let dest = dest.trim(".typ") + ".html"
    link_(dest, body)
  }

  My so many articles:

  #{
    let content = read("articles/index.txt")

    for article in content.split() {
      let article_path = "articles/" + article
      import article_path as article
      [
        #link(article_path)[#article.name]
      ]
    }
  }
]
