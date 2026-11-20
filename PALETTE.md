# tanuki-night — palette & highlight spec

Sampled from 19 screenshots (C, header .h, Rust, Zig, Makefile). Hex = exact pixel values.
Palette matches the Tomorrow Night family (canonical values in brackets; screenshots are
color-managed by macOS, so the sampled values read slightly desaturated).

## Palette

| Role          | Sampled   | Canonical |
|---------------|-----------|-----------|
| bg            | `#1d1f21` | `#1d1f21` |
| bg_alt (header bar) | `#28272d` | — |
| bg_button     | `#4f4e53` | — |
| fg            | `#c6c8c6` | `#c5c8c6` |
| comment       | `#969896` | `#969896` |
| line_nr       | `#616264` | — |
| cursorline_nr bg | `#453793` | — |
| cursorline_nr fg | `#7d73b3` | — |
| red           | `#bf6b69` | `#cc6666` |
| orange        | `#d39668` | `#de935f` |
| yellow        | `#e9c880` | `#f0c674` |
| green         | `#b6bd73` | `#b5bd68` |
| aqua          | `#95bdb7` | `#8abeb7` |
| blue          | `#88a1bb` | `#81a2be` |
| purple        | `#ad95b8` | `#b294bb` |

Gutter: same bg as editor, no visible separator in Neovim terms (the thin line in
screenshots is a 1px border — map to `WinSeparator`/`LineNr` with no bg change).

## Syntax mapping (observed)

| Token | Color | Evidence |
|---|---|---|
| Plain identifiers, fields, method calls, operators (C/Rust), punctuation | fg | everywhere |
| Comments (`//`, `/* */`, `///`, `//!`, `#`, doc tags `@file`) | comment | all |
| Rust attributes `#![...]`, `#[derive(...)]` | comment | main.rs |
| Strings, chars (`'\0'`, `'b'`), escapes `\n`, fmt `{}`, `<header.h>`, `"header.h"` | green | all |
| Numbers (`0`, `256`, `0x80`, `1u`) | orange | ascii.c, rs, zig |
| Control keywords (`if else for while do return break switch case default match in`) | purple | all |
| Rust/Zig keywords (`use fn let mut const pub struct enum impl try orelse`) | purple | rs, zig |
| Preprocessor `#include #define #ifdef #ifndef #endif #if` | purple | C |
| C storage/type keywords (`static const unsigned int char void bool`), typedef names (`or_options_t`, `uint16_t`, `tor_addr_t`) | yellow | C |
| C `struct`/`typedef`/`enum` keyword | purple | ascii.c, .h |
| Rust prelude/builtin types (`Option String Result Vec str u16 u8`) and decl names (`struct Tool`, `enum Channel`) | yellow | rs |
| Rust non-builtin type usage (`Stage0Config`, `IndexMap`, `Error`, `Channel::Stable`) | fg | rs |
| Zig primitive types (`u8 usize`) | yellow; `void`, `const` in `[]const` | purple |
| Function names at definition (C), `fn new`, `fn fetch_manifest` | blue | C, rs |
| C function parameters | blue | ascii.c, tor |
| Zig method calls (`.writeStreamingAll`, `.length`, `.sliceTo`, `.dupe`) | blue; zig decl names (`getenv`) | fg |
| Rust `let` binding names (`channel`, `version`, `url`) | red | rs |
| Rust `self`, `Some` | red; `Self` | purple |
| `true false NULL null undefined` | purple | C, zig |
| Zig operators (`= == ? !`) | aqua | compat.zig |
| Macros (`format!`, `anyhow::bail!`), `@import`, `@memcpy`, `sizeof` | fg | rs, zig, C |
| Rust `?` operator | fg | rs |
| Makefile `$(VAR)`, `$<`, `$(shell ...)` body | red | Makefile |
| Makefile targets (`all:`, `install:`, `.SUFFIXES:`) | green; `.PHONY` | purple |
| Makefile assignments `PREFIX ?=`, recipes | fg | Makefile |
| Tor C: preprocessor operand macros (`HAVE_UNISTD_H`) | comment-grey | main.c |

Note: the screenshots come from two different highlighters (tor = C via one engine,
ascii.c via another), hence minor conflicts (e.g. C params blue, Rust params plain).
Spec picks the majority look.

## Round 2 findings (images/round2/, 37 shots)

Decision: theme uses the **canonical** Tomorrow Night hex values (screenshots read slightly
desaturated because of macOS color management + JPEG).

| Language | Observed |
|---|---|
| TS / JS / Vue | `import from as const export async await new` purple; PascalCase types/classes yellow; `SCREAMING_CASE` red; `this null` purple; method calls blue; params plain |
| Python | `class def if return` purple; class name yellow; decorators aqua; def names, `self/cls`, params plain; method calls blue |
| Lua | keywords purple; params blue; function names, `{}` plain |
| Go | `type func const defer return` purple; builtin types + conversions `string(s)` yellow; user types/funcs plain; receiver/params blue |
| Ruby | symbols `:foo` and hash keys `key:` green; `true` purple; method calls plain |
| C++ | like C: `static void int bool` yellow, `constexpr namespace` purple, params blue, function defs plain |
| Shell | shebang grey; keywords purple; all variables (`x=`, `$x`, `${x}`) red; commands plain |
| SCSS / CSS | `@mixin` purple; `$var` red; `.class` yellow; `:pseudo` aqua; properties/values plain |
| YAML | keys blue; values green |
| JSON / TOML | keys + `[sections]` plain; strings green |
| Markdown | headings green; link text green; URLs orange |
| HTML | tags plain; attributes blue; values green |

## UI colors (sampled)

| Element | Color |
|---|---|
| Selection (Visual) | `#2e3a4a` |
| `#L` target line | `#753217` (used for Search bg, blended) |
| Diff added line / word | `#283627` / `#3a5836` |
| Diff removed line | `#462627` |
| Diff filler (hatched) | `#28272d` |
| Hunk header | `#353638` |
| Dropdown / float bg | `#28272d`, hover `#3a373e` |
| Focus accent (inputs) | `#5d87c3` |
