#let title = ("test page", [Test article :3])
#let published-date = datetime(year: 2025, month: 12, day: 8)
#let description = [
  This is a test article in which we test your browser's ability to meow.
]

#import "/lib/main.typ" as lib

#show: lib.page.with(
  title: title,
  date: published-date,
)

#lib.paragraph-name[Latin stuff (boring)]
#lorem(50)

= owo

(presumably)

```rust
fn main() {}
```

