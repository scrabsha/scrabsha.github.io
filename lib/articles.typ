#let title-ascii(title) = {
  if title == none {
    none
  } else if type(title) == str {
    title
  } else if type(title) == array {
    title.at(0)
  }
}

#let content = read("../content/articles/index.txt")

#let articles = {
  content
    .split()
    .map(article => {
      let fs_path = "../content/articles/" + article
      let path = "articles/" + article
      import fs_path as article
      (path, article)
    })
    .sorted(key: article => article.at(1).published-date)
    .rev()
}

#let items = {
  let rss = toml("../.env").rss
  let items = articles.map(article => {
    let path = article.at(0)
    let path = path.trim("../content", at: start).trim(".typ", at: end) + ".html"
    let mod = article.at(1)
    let title = title-ascii(mod.title)
    let link = rss.root-url + "/" + path
    let date = article.at(1).published-date
    let date = date.display("[day] [month repr:long] [year] 00:00:00 +0000")
    (title: title, link: link, date: date)
  })

  items
}

#let fmt-item(item) = {
  (
    "<item>"
      + "<title>"
      + item.title
      + "</title>"
      + "<link>"
      + item.link
      + "</link>"
      + "<guid isPermaLink=\"true\">"
      + item.link
      + "</guid>"
      + "<pubDate>"
      + item.date
      + "</pubDate>"
      + "</item>"
  )
}

#let rss-header = {
  let rss = toml("../.env").rss
  let atom = rss.root-url + "/articles/rss.xml"
  (
    "<title>"
      + rss.title
      + "</title>"
      + "<link>"
      + rss.root-url
      + "</link>"
      + "<description>"
      + rss.description
      + "</description>"
      + "<language>"
      + rss.language
      + "</language>"
      + "<ttl>"
      + str(rss.ttl)
      + "</ttl>"
      + "<copyright>"
      + rss.copyright
      + "</copyright>"
  )
}

#let penis = {
  let buf = ""

  buf = buf + "<rss version=\"2.0\">"
  buf = buf + "<channel>"
  buf = buf + rss-header
  for item in items {
    buf = buf + fmt-item(item)
  }
  buf = buf + "</channel>"
  buf = buf + "</rss>"

  buf
}

#metadata(penis)<rss>
