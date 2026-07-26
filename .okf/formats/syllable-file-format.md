---
type: File Format
title: Syllable file format (.txt)
description: Line-oriented grammar for language files — one syllable per line, a position sigil, and optional adjacency flags.
tags: [format, domain, languages]
timestamp: 2026-07-26T00:00:00Z
---

The syllable file is the domain data of this project; everything in
`lib/` is machinery for reading it. The format is deliberately plain text so a
language can be authored, diffed, and reviewed by hand.

# Schema

One syllable per line. Blank lines are ignored. Leading/trailing whitespace is
stripped and the whole line is downcased.

```
[sigil]syllable [flag] [flag]
```

| Element | Values | Meaning |
|---------|--------|---------|
| sigil | `-` | Prefix — may only appear first in a name. |
| | `+` | Suffix — may only appear last. |
| | *(none)* | Middle. |
| syllable | any characters | The text contributed to the name. |
| flags | `+v` | The **next** syllable must start with a vowel. |
| | `+c` | The next syllable must start with a consonant. |
| | `-v` | The **previous** syllable must end with a vowel. |
| | `-c` | The previous syllable must end with a consonant. |

Flags are whitespace-separated and order-independent. `+v`/`+c` are mutually
exclusive (first wins), as are `-v`/`-c`.

```
-ang +c      prefix "ang", next syllable must begin with a consonant
bryn         middle, unconstrained
+wen -c      suffix "wen", only after a syllable ending in a consonant
```

# Authoring constraints

- **All three buckets must be non-empty.** A file with no suffixes cannot
  compose a name of two or more syllables.
- **Flags must be satisfiable.** If some syllable's `+v` has no vowel-initial
  candidate in the middle or suffix bucket, composition raises `ArgumentError`
  at generation time, not load time — see [Generator](/library/generator.md).
  Sparse buckets plus aggressive flags is the usual cause.
- Use flags only where the phonetics actually demand them. Most lines in the
  bundled languages carry none.

# Where the files live

Curated languages are in `lib/languages/`; edgier or less polished sets are in
`lib/languages/experimental/`. Cyrillic variants use the `-ru.txt` suffix and
rely on `Syllable`'s Cyrillic character classes. See the
[language catalog](/languages/catalog.md) and
[adding a language](/languages/adding-a-language.md).

Test fixtures in `spec/languages/` exercise the edges of the format:
`test-blank.txt` (blank lines), `test-micro.txt` (one syllable per bucket, no
trailing newline), `test-tiny.txt` (every flag combination), and
`test-incompatible.txt` (a file whose flags cannot be satisfied).

# Citations

[1] [Syllable class documentation](https://github.com/folkengine/random_name_generator/blob/main/lib/random_name_generator/syllable.rb)
[2] [java-random-name-generator](https://github.com/folkengine/java-random-name-generator) — the port's origin; the format is inherited from it.
