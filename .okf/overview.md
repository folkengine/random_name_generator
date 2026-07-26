---
type: Project
title: random_name_generator
description: Ruby gem that composes names from per-language syllable files, shipping a library API and a CLI.
resource: https://github.com/folkengine/random_name_generator
tags: [ruby, gem, overview]
timestamp: 2026-07-26T00:00:00Z
---

A Ruby gem (3.4+) that builds names — Elven, Goblin, Roman, Klingon, Belter,
Welsh, and more — by assembling syllables drawn from plain-text language files.
It is a port of
[java-random-name-generator](https://github.com/folkengine/java-random-name-generator),
which descends from Sinipull's GPL'd post on codecall.net. Published as
[random_name_generator](https://rubygems.org/gems/random_name_generator) under
LGPL-3.0.

# Shape

```
lib/languages/*.txt        the domain data — syllables + adjacency flags
lib/random_name_generator/syllable.rb   parses one line
lib/random_name_generator.rb            constants, factories, Generator
exe/random_name_generator               slop-based CLI
```

The whole system is one idea: a **syllable file** is a list of prefixes,
middles, and suffixes, each optionally constrained by what may precede or
follow it. Everything else reads that file and samples from it.

| Layer | Concept |
|-------|---------|
| Data format | [Syllable file format](/formats/syllable-file-format.md) |
| Parsing | [Syllable](/library/syllable.md) |
| Composition | [Generator](/library/generator.md) |
| Public API | [RandomNameGenerator module](/library/module.md) |
| Command line | [CLI](/interfaces/cli.md) |
| The data itself | [Language catalog](/languages/catalog.md) |

# Properties

- **Pure**: file in, string out. No network, no threads, no global mutable
  state beyond the shared `File` constants.
- **Seedable**: randomness is injected, not global — see
  [that decision](/decisions/injected-randomness.md).
- **Extensible by data**: adding a language means adding a text file and
  wiring it up, not changing the algorithm. See
  [adding a language](/languages/adding-a-language.md).

# Working here

`bundle exec rake` is the gate (spec then rubocop) —
see [build and test](/development/build-and-test.md) and
[conventions](/development/conventions.md).

# Citations

[1] [README.md](https://github.com/folkengine/random_name_generator/blob/main/README.md)
[2] [RandomNameGeneratorHub](https://github.com/folkengine/RandomNameGeneratorHub) — ports in other languages.
