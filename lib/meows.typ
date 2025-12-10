#import "@preview/suiji:0.5.0": *

#let all-meows = (
  "mrrrrp",
  "purrrr",
  "mrrrrmph",
  "nya",
  "meow",
  "miao",
  "mrow"
)

#let meows(seed: datetime.today(), density: 2, body) = {
  let nonrecursive-label = <meow-stop-recursion>

  let nonrecursive(body) = [
    #body <meow-stop-recursion>
  ]

  let should-insert-meow(rng) = {
    let a = ()
    (rng, a) = integers(rng, high: density)
    let a = a == 0
    (rng, a)
  }

  let random-meow(rng) = {
    let meow-idx = none
    (rng, meow-idx) = integers(rng, high: all-meows.len())
    let meow = all-meows.at(meow-idx)
    let meow = html.span(class: "meow", nonrecursive(meow))
    (rng, meow)
  }

  let is-already-processed(body) = {
    body.has("label") and body.label == nonrecursive-label
  }

  show text: it => {
    if is-already-processed(it) {
      return it
    }

    let body = []
    let a = ()
    let rng = gen-rng-f((seed.day()) * 366 + seed.month() * 31 + seed.year())

    for word in it.text.split(" ") {
      body += nonrecursive(word)

      (rng, a) = should-insert-meow(rng)

      if a {
        let meow = ()
        (rng, meow) = random-meow(rng)
        body += nonrecursive(meow)
      }
    }

    nonrecursive(body)
  }

  body
}
