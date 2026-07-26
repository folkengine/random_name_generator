---
type: Ruby Class
title: RandomNameGenerator::Syllable
description: Parses one line of a language file into a syllable plus its position and adjacency rules, and answers compatibility questions.
resource: https://github.com/folkengine/random_name_generator/blob/main/lib/random_name_generator/syllable.rb
tags: [ruby, api, parsing]
timestamp: 2026-07-26T00:00:00Z
---

`Syllable` absorbs all the parsing complexity of the
[syllable file format](/formats/syllable-file-format.md) so that
[Generator](/library/generator.md) only has to sample from arrays and ask
`compatible?`. It is not meant to be called directly in normal use.

Extracting this class is the main structural departure from the Java original
the gem was ported from.

# Parsing

`Syllable.new(args)` accepts a `String` line, or another `Syllable` (which
clones it via `#raw`). The line is stripped, **downcased**, and split on
whitespace:

- token 0 is the syllable, matched against `/([+-]?)(.+)/` — a leading `-`
  sets `prefix?`, a leading `+` sets `suffix?`, anything else is a middle;
- remaining tokens are flags, order-independent.

An empty syllable raises `ArgumentError, "Empty String is not allowed."`.
Note that flags are matched by exact token, so an unrecognized flag is
silently ignored rather than rejected.

# Compatibility

Two independent rules decide whether syllable B may follow syllable A —
`A.compatible?(B)` is false if either fails:

| Rule | Source | Meaning |
|------|--------|---------|
| next | `A`'s `+v` / `+c` | B must *start* with a vowel / consonant. |
| previous | `B`'s `-v` / `-c` | A must *end* with a vowel / consonant. |

Both requirements default to `:letter` (unconstrained). Within each pair the
parse is `if/elsif`, so a line carrying both `+v` and `+c` keeps only `+v`,
and one carrying both `-v` and `-c` keeps only `-v`.

# Character classes

`VOWELS` and `CONSONANTS` are frozen arrays of single-character strings
covering Latin, extended IPA-ish, and Cyrillic letters — this is what lets the
Cyrillic language files work with the same engine. Membership is tested on
`syllable[0]` and `syllable[-1]`.

`y` is deliberately in **both** sets: as a semivowel it satisfies either a
`+v` or a `+c` requirement. A character in *neither* set (a digit, an
apostrophe) makes both `vowel_last?` and
`consonant_last?` false, which means it can never violate a `-v`/`-c`
requirement — such a syllable is universally acceptable as a predecessor.

# Public surface

| Member | Notes |
|--------|-------|
| `#compatible?(next)` / `#incompatible?(next)` | The pair used by `Generator`. |
| `#prefix?` / `#suffix?` | Bucket assignment. |
| `#vowel_first?` / `#consonant_first?` / `#vowel_last?` / `#consonant_last?` | Class membership of the first/last character. |
| `#next_syllable_universal?`, `#next_syllable_must_start_with_vowel?`, `#next_syllable_must_start_with_consonant?` | Reads of `next_syllable_requirement`. |
| `#previous_syllable_universal?`, `#previous_syllable_must_end_with_vowel?`, `#previous_syllable_must_end_with_consonant?` | Reads of `previous_syllable_requirement`. |
| `#raw` | The original stripped line — including sigil and flags. |
| `#to_s` / `#to_str` | The bare syllable text; `to_str` makes it implicitly coercible in string ops. |

# Examples

```ruby
s = RandomNameGenerator::Syllable.new("-foo +c")
s.prefix?                                   # => true
s.to_s                                      # => "foo"
s.raw                                       # => "-foo +c"
s.next_syllable_must_start_with_consonant?  # => true
```

# Citations

[1] [lib/random_name_generator/syllable.rb](https://github.com/folkengine/random_name_generator/blob/main/lib/random_name_generator/syllable.rb) — the class doc there is the authoritative statement of the rules.
