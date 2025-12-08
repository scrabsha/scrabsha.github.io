#let name = "this is a test article"
#let published-date = datetime(year: 2025, month: 12, day: 8)

#import "/lib/main.typ" as lib

#show: lib.page.with(
  title: ("rustc as a hobby", [`rustc` as a hobby]),
  date: published-date
)

= owo

(presumably)

```rust
fn main() {}
```

