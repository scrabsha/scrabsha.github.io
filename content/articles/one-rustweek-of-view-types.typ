#let title = ("One RustWeek of view_types", [One RustWeek of `view_types`])
#let published-date = datetime(year: 2026, month: 5, day: 30)

#import "../../lib/main.typ" as lib
#show: lib.page.with(title: title, date: published-date)

#let gh-profile(username) = link("https://github.com/" + username, raw(username))
#let issue-1 = link("one-week-of-view-types.html")[One week of `view_types`]

#let description = [
  Last week I attended to #link("https://2026.rustweek.org/")[RustWeek 2026] with the intent of bumping into as many people as possible and asking them about view types. Many people much smarter than me gave me tons of good ideas.
]

#lib.paragraph-name[Note] This is the second part of my blogposts about my work on the `view_types` feature. I don't think reading the first part is required; if anything, it explains the title of _this_ blogpost. Anyway it can be found here: #issue-1.

#description

More precisely, I attended both the conference (and even volunteered a bit!) and the All Hands that followed. It was interesting to see how different the conversations were in these two spaces. On one side, people were super excited about view types - someone even asked me when it would reach _stable_. On the other, people asked me very specific implementation details. There was a super clean divide between "consumer of the feature" and "`rustc` maintainer". It makes complete sense in retrospect, but I would never have guessed.

#lib.paragraph-name[Contiguous memory issue] In #issue-1, I briefly described how view types could be leveraged to create a type-checked, non-generic builder pattern. This is totally cool, but I was missing something important: in Rust, it is assumed that holding a `&mut T` gives you write access to every byte of `T`. This means the following is perfectly valid:

```rust
fn copy<T>(src: T, dst: &mut T) {
    unsafe extern "C" {
        fn memcpy(n: usize, dest: *mut c_void, src: *const c_void);
    }

    // SAFETY: meow.
    unsafe {
        memcpy(
            size_of::<T>(),
            &raw mut *dst as *mut c_void,
            &raw const src as *const c_void,
        );
    }
}
```

This is unsound when view types are introduced:

```rust
struct Foo {
    meow: u8,
    nyya: u8,
}

fn main() {
    let mut foo = Foo { meow: 42, nyya: 101 };
    let meow = &foo.meow;
    copy(Foo { meow: 69, nyya: 69 }, &mut foo as &mut Foo.{ nyya });
    println!("{meow}");
}
```

What should this program print? We borrowed `foo.meow` before calling `copy`, and `copy` should not have access to `foo.meow` given that `meow` is not viewable. But also, `memcpy` very much copied some data right over `foo.meow`, so what?

This problem was pointed out to me by #gh-profile("oli-obk"), and he immediately came up with a solution: making view types `!MetaSized`, aka "can't get its size, even at runtime" (see work on #link("https://github.com/rust-lang/rust/issues/144404")[RFC 3729 - `size_hierarchy`]), and with a HORRIBLE hack to keep a simple-ish builder pattern. Later during the all-hands, #gh-profile("BennoLossin") suggested to add a `Contiguous` marker trait to every type that is not a view type, and add implicit bounds \~everywhere. I think this is cleaner, but I have no clue how much this would hurt trait solving performance.

#lib.paragraph-name[View type vs view reference] In the previous issue, I mentioned how view types could be useful both for `Foo` and `&[mut] Foo` for completely different reasons. While browsing the Rust Zulip, I discovered the field projection folks already thought about it and briefly mentioned it on Zulip (#link("https://rust-lang.zulipchat.com/#narrow/channel/522311-t-lang.2Fcustom-refs/topic/Places.20and.20View.20Types/near/597378474")[🌍 t-lang/custom-refs > Places and View Types @ 💬]). The ideas are roughly the same as what I wrote: view references allow borrowing some fields mutably or immutably, perhaps with different lifetimes. Everybody agrees this would be neat, nobody agrees on the syntax. Sick.

#lib.paragraph-name[Placement new] Before RustWeek I had some ideas of how view types could be used to model placement new. Something along the lines of:

```rust
fn init_value(foo: &mut Foo.{}) -> &mut Foo {
    // stuff goes here ig
}
```

But during the very first day of the All Hands I bumped into the people designing in-place initialization. They want to do it in a way that is much cleaner than what I wrote above, which is much much cooler IMO.

#lib.paragraph-name[`rustc` devs are so cool] When I had nothing special to do, I simply sat down and tried to make some progress on `view_types`. Occasionally cool `rustc` devs would bump into me and I would bother them with my questions.

It took me 10 minutes of talking with #gh-profile("jdonszelmann") to understand how `rustc_type_ir` and `rustc_middle` interact with each other - and most importantly why the code is structured that way. My head still hurts when I have to touch anything in these crates, but at least now I know why.

I also bothered #gh-profile("JonathanBrouwer") quite a lot when I was trying to make the encoding and decoding of view types ~compile. I ended up writing the fix myself (or most of it? I am too tired to remember), but it would have taken me hours to figure out what Jonathan found in like 10 minuten. It was very interesting to see them diving head first in the codebase and figuring things out in their own way.

More generally, I had a lot of discussions with people who really _care_ about Rust. It was refreshing to see very competent people talk about things they are experts in with such a passion. It really strengthened in me the idea that open source is a social problem much more than a technical one. Once again, #link("https://donsz.nl/blog/externally-implementable-items")[It's the people that matter]!
