---
type: Catalog
title: Language catalog
description: Every bundled syllable file — its constant, path, CLI flag, and bucket sizes.
tags: [languages, data, catalog]
timestamp: 2026-07-26T00:00:00Z
---

Fourteen syllable files ship with the gem. Each is bound to a `File` constant
on [the module](/library/module.md) and, where user-facing, to a
[CLI](/interfaces/cli.md) flag.

# Curated languages

| Constant | File | CLI | pre / mid / suf |
|----------|------|-----|-----------------|
| `FANTASY` | `lib/languages/fantasy.txt` | *(default)* | 179 / 153 / 18 |
| `ELVEN` | `lib/languages/elven.txt` | `-e` | 36 / 21 / 27 |
| `GOBLIN` | `lib/languages/goblin.txt` | `-g` | 19 / 13 / 16 |
| `ROMAN` | `lib/languages/roman.txt` | `-r` | 15 / 10 / 10 |
| `KLINGON` | `lib/languages/klingon.txt` | `-k` | 40 / 35 / 36 |
| `BELTER` | `lib/languages/belter.txt` | `-b` | 35 / 40 / 27 |
| `WELSH` | `lib/languages/welsh.txt` | *(none)* | 35 / 32 / 24 |

`WELSH` is reachable from the library but has **no CLI flag** — the one gap
between the constant set and `exe/random_name_generator`.

# Cyrillic variants

Same four base styles, transliterated into Cyrillic syllables. They work
because `Syllable::VOWELS` and `CONSONANTS` include the Cyrillic alphabet
(see [Syllable](/library/syllable.md)).

| Constant | File | CLI | pre / mid / suf |
|----------|------|-----|-----------------|
| `FANTASY_RU` | `lib/languages/fantasy-ru.txt` | `-c` | 180 / 157 / 19 |
| `ELVEN_RU` | `lib/languages/elven-ru.txt` | `-c -e` | 36 / 21 / 27 |
| `GOBLIN_RU` | `lib/languages/goblin-ru.txt` | `-c -g` | 19 / 13 / 16 |
| `ROMAN_RU` | `lib/languages/roman-ru.txt` | `-c -r` | 15 / 10 / 10 |

The Cyrillic set is what `-c` selects, and it is also the pool for
`RandomNameGenerator.flip_mode_cyrillic`. `KLINGON`, `BELTER`, and `WELSH`
have no Cyrillic counterpart, so `-c -k` silently yields `FANTASY_RU`.

# Experimental languages

Edgier, less curated sets under `lib/languages/experimental/`. Opt-in only.

| Constant | File | CLI | pre / mid / suf |
|----------|------|-----|-----------------|
| `CURSE` | `experimental/curse.txt` | `-x` | 24 / 7 / 32 |
| `DEMONIC` | `experimental/demonic.txt` | `-d` | 111 / 64 / 73 |
| `GERMAN_CURSE` | `experimental/german-curse.txt` | `-ß` | 105 / 98 / 127 |

`CURSE` and `GERMAN_CURSE` are marked `[NEEDS WORK]` in the CLI help.
`CURSE`'s middle bucket holds only 7 syllables, so names of three or more
syllables repeat heavily. `GERMAN_CURSE` was produced by the `lang-gen` skill
and is the worked example for [adding a language](/languages/adding-a-language.md).

# Flip mode

`RandomNameGenerator.flip_mode` samples only `FANTASY`, `ELVEN`, `GOBLIN`, and
`ROMAN` — the four original styles. New languages are **not** picked up by
flip mode automatically; the arrays in `lib/random_name_generator.rb` are
hard-coded.

# Citations

[1] [lib/random_name_generator.rb](https://github.com/folkengine/random_name_generator/blob/main/lib/random_name_generator.rb)
[2] [README — Usage](https://github.com/folkengine/random_name_generator/blob/main/README.md)
