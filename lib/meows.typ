#import "@preview/suiji:0.5.0": *

#let all-meows = (
  "mrrrrp",
  "purrrr",
  "mrrrrmph",
  "nya",
  "meow",
  "miao",
  "mrow",
  "kekekeke", // cat chirping
  "ma-ah", // Grisette's contribution, I can only assume that it means stop whatever the fuck you're doing and gove me attention 
  "meeeeeeeee" // Harley's long meow (the o and w are silent in the Siamese accent) it has the same meaning as Grisette's "ma-ah"
)

#let meows(density: 2, body) = {
  let nonrecursive-label = <no-meow>

  let nonrecursive(body) = [#body#nonrecursive-label]

  let should-insert-meow(rng) = {
    let a = ()
    (rng, a) = integers(rng, high: density - 1)
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

  let hash(string) = {
    // FNV-1A (32bits)
    let state = 2166136261
    for char in string {
      state = calc.rem-euclid(state.bit-xor(char.to-unicode()) * 16777619, 4294967295)
    }

    state
  }

  show text: it => {
    if is-already-processed(it) {
      return it
    }

    let body = []
    let a = ()

    let seed_ = 2166136261
    for char in it.text {
      seed_ = calc.rem-euclid(seed_.bit-xor(char.to-unicode()) * 16777619, 4294967295)
    }

    let seed = hash(it.text)
    let rng = gen-rng-f(seed)

    let words = it.text.split(" ")

    if words.len() >= 1 {
      body += nonrecursive(words.at(0))
    }

    for idx in range(1, words.len()) {
      let word = words.at(idx)
      body += [ ]

      (rng, a) = should-insert-meow(rng)
      if a {
        let meow = ()
        (rng, meow) = random-meow(rng)
        body += nonrecursive(meow)
        body += [ ]
      }

      body += nonrecursive(word)
    }

    nonrecursive(body)
  }

  body
}
