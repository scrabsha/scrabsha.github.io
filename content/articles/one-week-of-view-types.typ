#let title = ("One week of view_types", [One week of `view_types`])
#let published-date = datetime(year: 2026, month: 5, day: 5)

#import "../../lib/main.typ" as lib
#show: lib.page.with(title: title, date: published-date)

#let description = [
  I started working on the view_types (rust-lang/rust#155938) about a week ago. At first, I had no strong opinion on what view types should look like in terms of syntax. Well. Thinking about `view_types` for more than an hour per day every day is a good way to form strong opinions about the said `view_types`. I should have expected that, honestly.
]

#let rust-lang-ref(id) = {
  link("https://github.com/rust-lang/rust/issues/" + str(id))[rust-lang/rust\##id]
}

I started working on the `view_types` (#rust-lang-ref(155938)) about a week ago. At first, I had no strong opinion on what `view_types` should look like syntax-wise. I wanted to add basic support of `view_types` while the Lang Team discusses what it should look like, and just update my implementation every time they reach a concensus.

Well. Thinking about `view_types` for more than an hour per day every day is a good way to form strong opinions about the said `view_types`. I should have expected that, honestly.

This post is a bit half-baked. I could write about `view_types` for hours at this point, but right now my focus is to jot down everything I thought about in the past days. Maybe we'll be able to see how my views (🥁) change over time.

#lib.paragraph-name[View types for `&T`] Something I did not consider at first is that expressing both immutable and mutable borrows could be useful. For instance:


```rust
struct Foo {
    bar: usize,
    baz: usize,
}

impl Foo {
    fn show_bar(&self.{ bar }) {
        println!("The value of `bar` is `{}`", self.bar);
    }
}

fn main() {
    let mut foo = Foo { bar: 42, baz: 101 };
    // Mutable borrow created *before* the function call
    let baz = &mut foo.baz;
    foo.show_bar();
    // Mutable borrow used *after* the function call
    *baz += 1;
}
```

In this example, it is perfectly fine to call `Foo::show_bar` because the set of fields it needs to view `{ bar }` is disjoint.

We could even allow things like `&mut self.{ foo, mut bar }` for "this function may view _immutably_ the field `foo` and _mutably_ the field `bar`". I am not sure whether we should have a `mut` right after the `&`, I'm not sure I care.

#lib.paragraph-name[View types for `T`] Supporting views for `T` _in addition_ to `&T` would allow us to pass partially initialized data to functions, and have a type-checked builder pattern that does not require generic type parameters to keep track of its state:

```rust
struct Foo {
    bar: usize,
    baz: usize,
}

impl Foo {
    fn new() -> Foo.{} {
        Foo {}
    }
    fn with_bar(self.{ ..fields }, bar: usize) -> Foo.{ bar, ..fields } {
        Foo {
            bar,
            ..self
        }
    }
    fn with_baz(self.{ ..fields }, baz: usize) -> Foo.{ baz, ..fields } {
        Foo {
            baz,
            ..self
        }
    }
}

fn main() {
    let foo = Foo::new()   // Foo.{}
        .with_bar(42)      // Foo.{ bar }
        .with_baz(101);    // Foo.{ bar, baz } (aka Foo)
}
```

Here we _bind_ the possibly viewable fields of `self` to the _view group_ `fields` and use this group in the return type. This is how `Foo::with_bar`'s return type indicates that its return type can be viewed at `bar`, as well as the same fields as its receiver.

I am using `..fields` here because I feel like this concept is actually close to the struct update syntax (#link("https://doc.rust-lang.org/reference/expressions/struct-expr.html#r-expr.struct.update")[`r-expr.struct.update`]), but my first drafts of this blogpost used `.{ fields @ .. }` and `.{ ..fields }` because I was curious about how this can blend with pattern types. I am not sure I care about which syntax we end up using.

#lib.paragraph-name[Different lifetimes] Something that came to my mind quite late this week is: people may want to borrow different fields for different lifetimes, and I don't really see any way to express this using this syntax. I am not really willing to sit down and come up with a syntax for this and will instead proceed to: ignore this idea completely for now and hope someone smarter will think about it for me 👍. I would be happy to implement support for this using any syntax that is vaguely reasonable, though.

#lib.paragraph-name[Is the syntax _really_ ugly?] Something I wrote down quite early in my notes is: "I hope the syntax will be changed to something less horrible". After a week, I am fully used to it. I even think it is fine?

I do remember feeling the exact same thing about `let_else` the first time I encountered it: why would one use this monstruosity that I keep parsing as an `if` `else`? I was sad and disappointed. For months. Then I got involved in `rustc`'s attribute refactor (#rust-lang-ref(131229)), and started reading dozens of `let_else` every day. Now I cannot refrain from using use `let_else`. Everywhere. And I do get frowny when I can't use it in other languages.

Maybe it's just a _me thing_, but I think `.{ foo, bar }` is fine, really.
