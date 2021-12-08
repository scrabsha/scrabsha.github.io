+++
title = "A better cargo-readme - Issue 0: Humble Beginning"
date = 2021-12-06
updated = 2021-12-08
+++

# Introduction

I'm bad at writing READMEs for my Rust crates. Most of the time, I use [`cargo-readme`]. This program reads my code, extracts its crate-level documentation, and generates a cute README file, which will be displayed on [crates.io]. Let's consider the following small Rust crate:

[`cargo-readme`]: https://github.com/livioribeiro/cargo-readme
[crates.io]: https://crates.io

```rust
//! # My crate
//!
//! Here's some crate-level documentation.

/// A public data structure
pub struct S;
```

When invoked on this crate, cargo-readme should generate the following markdown code:

```markdown
# abcr_step0

## My crate

Here's some crate-level documentation
```

The goal of cargo-readme is to make the README file rendered on [crates.io] very close to what the user would read if they open the crate documentation on [docs.rs]. It is used in real-world Rust crates such as `bumpalo` (compare its [README][bumpalo-readme] and its [actual documentation][bumpalo-docsrs]). So far so good.

[docs.rs]: https://docs.rs
[bumpalo-readme]: https://github.com/fitzgen/bumpalo/blob/master/README.md#bumpalo
[bumpalo-docsrs]: https://docs.rs/bumpalo/latest

I recently open-sourced [`dep_doc`], which uses macros to generate a cute dependency declaration snippet. To explain it briefly, the user can add a `#![doc = dep_doc::dep_doc!()]` somewhere in their crate-level documentation, and the following code snippet will be automatically generated in the crate documentation:

[`dep_doc`]: https://docs.rs/dep_doc/latest/dep_doc/

```TOML
[dependencies]
CRATE_NAME = "CRATE_VERSION"
```

What's interesting here is that `CRATE_NAME` and `CRATE_VERSION` are guaranteed to always refer to the current crate name and version, which prevents the users from forgetting to update the snippet before releasing.

Let's add a call to [`dep_doc`] to our crate to see if it handles our macro:

```rust
//! # My crate
//!
#![doc = dep_doc::dep_doc!()]
//!
//! Here's some crate-level documentation

/// A public data structure
pub struct S;
```

This gives us the following:

```markdown
# abcr_step0

## My crate
```

That's a bit embarassing. It should generate something like:

~~~markdown
# abcr_step0

```TOML
[dependencies]
abcr-step0 = "0.1.0"
```

## My crate

Here's some crate-level documentation
~~~

This means that [`dep_doc`] will break the README file of every Rustacean who use it. In order to understand why, we need to dive in [`cargo-readme`]'s source code. The whole algorithm is available in [`src/readme/extract.rs`]. To explain it briefly, it iterates over each line of the crate's `src/lib.rs` and saves every line which starts with `//!`, until it meets a line which starts with something else. This is fine for simple use case, but it will mess up each time it encounters something more complex, including macros.

[`src/readme/extract.rs`]: https://github.com/livioribeiro/cargo-readme/blob/master/src/readme/extract.rs

Once the crate-level documentation is extracted, very little processing is performed. Specifically, `#` headers are transformed in `##` headers and so on. As far as I know, no additional processing is performed. This means that intra-doc links are broken in the README file. Let's add one to our example snippet:

```rust
//! # My crate
//!
//! The [`Cow`] says moo 🐮
//!
#![doc = dep_doc::dep_doc!()]
//!
//! Here's some crate-level documentation

use std::borrow::Cow;

/// A public data structure
pub struct S;
```

This is rendered as:

```markdown
# abcr_step0

## My crate

The [`Cow`] says moo 🐮
```

See? The intra-doc link has been copied *as is* with no change whatsoever.

The problem here comes from the fact that [`cargo-readme`] takes a naive approach. Most notably, a Rust program is not a sequence of lines that we can analyze one after another in a single pass. Instead, it is a complete syntax tree where every node obeys to some special rules. It would make more sense to parse the input code instead of blindly generate the README file one line after another.

Parsing the input code is the approach that [`cargo-doc2readme`] takes. To explain briefly, it uses [`syn`] to create a syntax tree, extracts the imports and the crate documentation, resolves the intra-doc links thanks to the imports, and generates the output README file.

[`cargo-doc2readme`]: https://github.com/msrd0/cargo-doc2readme
[`syn`]: https://github.com/dtolnay/syn

This approach is a very good idea, but the problem is that we're processing raw syntax tree, which means that we can't have macro expansion. There's a little trick in which you parse the output of `cargo expand` instead of the `src/lib.rs` file. Actually, we're not calling `cargo expand`, but invoking Rustc with the correct command-line arguments. The idea is the same. This definitely works, but in my opinion, this is more a hack than an actual solution.

In this blogpost series, we will build our own `cargo-readme` tool. Instead of reading the input line by line, or traversing the crate's AST, we will use already-existing Rust tools to gather everything for us and retrieve data that has already been processed. We will try to implement as little algorithms as possible and rely as much as possible on Rust tools.

In this zeroth issue, we will focus on describing a new approach and show that it is good enough to solve our problem. We won't write Rust code at all. Instead, we will use high-level tools and bash commands.


# The basic idea

There's a well-known Rust tool that is responsible (among others) for expanding macros, extracting documentation and resolving intra-doc links. It is `rustdoc` itself. `rustdoc` is the command-line tool that is invoked by `cargo` each time a `cargo doc` is performed. It takes whole crate code, extracts the documentation for the public API and generates a bunch of wonderful HTML files that can be viewed in a browser. As far as i know, this tool is the only documentation generation tool in the Rust ecosystem. It would be very good if it could output something else than an HTML page. Let's look at its help page:

```
$ rustdoc --help
rustdoc [options] <input>

Options:
    -h, --help          show this help message
    -V, --version       print rustdoc's version
    -v, --verbose       use verbose output
    -r, --input-format [rust]
                        the input type of the specified file
    -w, --output-format [html]

<output skipped for brevity>
```

The `-w` option looks promising. By looking at [its documentation][-w-doc], we can learn that it is an *unstable feature* which accepts `json` and `html` as parameter. We could use the `json` output to extract the information we need. As this is an unstable feature, will use nightly toolchain (unless we use [the forbidden environment variable][rustc-bootstrap], but that's not a good idea).

[-w-doc]: https://doc.rust-lang.org/rustdoc/unstable-features.html#-w--output-format-output-format
[rustc-bootstrap]: https://rustc-dev-guide.rust-lang.org/building/bootstrapping.html#complications-of-bootstrapping

Let's run `rustdoc` with the `json` output format:

```
$ cargo +nightly rustdoc -- -Zunstable-options -wjson
Checking dep_doc v0.1.1
 Documenting abcr-step0 v0.1.0 (/tmp/abcr-step0)
    Finished dev [unoptimized + debuginfo] target(s) in 4.44s
```

I expected the output to be printed to stdout, but nothing appeared. Let's look at the `target` directory:

```
$ tree target/
target/
├── CACHEDIR.TAG
├── debug
│   ├── build
│   ├── deps
│   │   ├── dep_doc-31d529d57f7de8bf.d
│   │   └── libdep_doc-31d529d57f7de8bf.rmeta
│   ├── examples
│   └── incremental
└── doc
    └── abcr_step0.json

6 directories, 4 files
```

It looks like we're looking for the `target/doc/abcr_step0.json` file. Let's get a very rough estimate of the amount of data in it:

```
$ cat target/doc/abcr_step0.json | jq | wc -l
32034
```

Don't know what jq is? We'll discuss it shortly in the next section. For now, what matter is that the `cargo rustdoc` command we issued previously extracted a huge amount of data from the crate. We will use it to generate the appropriate README.


# Using jq to prove that it's possible

[`jq`] is a command-line tool which allows to extract data from JSON documents. We'll use it in order to extract specific pieces of the `rustdoc` output, and hopefully prove that we have everything needed for the README generation.

[`jq`]: https://stedolan.github.io/jq/


The JSON document follows a specific structure defined in the `rustdoc_json_types`'s [`Crate`] datatype. Knowing where and how each data is stored will allow us to write the correct `jq` commands.

[`Crate`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustdoc_json_types/struct.Crate.html


## Extracting the crate-level documentation

After a few minutes of diving in the data structures, we can see that all the items that are reachable from the crate are located in the [`index`] field. This field is a JSON dictionary whose keys are compiler-generated [`Id`]s and values are metadata of the reachable items. Additionally, there is a [`root`] field, which tells us which key in the index map will give us the documentation for the crate's root module.

Let's try to write a command which extracts the crate-level documentation using `jq`:

[`Id`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustdoc_json_types/struct.Id.html
[`root`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustdoc_json_types/struct.Crate.html#structfield.root
[`index`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustdoc_json_types/struct.Crate.html#structfield.index

```
$ cat target/doc/abcr_step0.json | jq '{docs: .index[.root].docs}'
{
  "docs": "# My crate\n\nThe [`Cow`] says moo 🐮\n\n```TOML\n[dependencies]\nabcr_step0 = \"0.1.0\"\n```\n\nHere's some crate-level documentation"
}
```

We did it! We managed to extract the crate documentation from the rustdoc-generated file. Additionally, the macros are expanded, which instantly solves one of our initial requirements.

## Extracting intra-doc link resolution

 By looking at the documentation for [`Item`], we can update our command to extract the [`links`] as well:
 
[`Item`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustdoc_json_types/struct.Item.html
[`links`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustdoc_json_types/struct.Item.html#structfield.links

```
$ cat target/doc/abcr_step0.json | jq '{ docs: .index[.root].docs, links: .index[.root].links }'
{
  "docs": "# My crate\n\n```TOML\n[dependencies]\nabcr_step0 = \"0.1.0\"\n```\n\nHere's some crate-level documentation\n\nHere's a link to [`Cow`].",
  "links": {
    "`Cow`": "5:546"
  }
}
```

This returns the [`Id`] of the [`Item`] that is linked. Let's see if we can retrieve its path:

```
$ cat target/doc/abcr_step0.json | jq '{ links_to_cow: .paths."5:546".path }'
{
  "links_to_cow": [
    "alloc",
    "borrow",
    "Cow"
  ]
}
```

This proves that we can retrieve the path to the item that is linked. Awesome.

We could spend time writing a more complex `jq` command which fetches the intra-doc links and resolves all of them in one pass, but the goal here is to prove that it is possible, rather than building a complete tool using half-backed shell commands.

# Conclusion

In this blogpost we listed the different README generators in the Rust ecosystem. We explained their different approaches and detailed their pros and cons. Finally, we suggested that we could use an already-existing Rust tool, `rustdoc`, to gather data for us, and analyze it ourselves.

Next issue will focus on writing an actual Rust program which extracts crate-level documentation, and prints it in the terminal.

This issue was reviewed by volunteers who gave me a lot of feedback. They are, in alphabetical order:
  - [Julia REPL stan account](https://twitter.com/miguelraz_),
  - [Mingwei Zhang 🦀](https://twitter.com/heymingwei),
  - [Natsukoh](https://twitter.com/natsukoow),
  - [Yozhgoor 🦀](https://twitter.com/yozhgoor).

Initial release of the blogpost used a hardcoded `id` to retrieve the crate-level documentation. [@aDotInTheVoid] suggested to use the `root` field instead. Thanks!

[@aDotInTheVoid]: https://github.com/aDotInTheVoid

If you're interested in reviewing the next articles or implementation, don't hesitate to message me on Twitter. I gladly welcome any kind of constructive feedback.
