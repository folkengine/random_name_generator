---
type: CLI
title: random_name_generator (executable)
description: The slop-based command line interface — one boolean flag per language, printing a two-name pair.
resource: https://github.com/folkengine/random_name_generator/blob/main/exe/random_name_generator
tags: [cli, interface]
timestamp: 2026-07-26T00:00:00Z
---

```shell
$ bundle exec exe/random_name_generator [-egrkbfcxdß?]
$ random_name_generator --german-curse     # after `bundle exec rake install`
Dummkopfischpopelsepp Schnoddmistmann
```

The script always prints **two** composed names separated by a space —
a first and last name — each with a randomly drawn syllable count.

# Flags

| Flag | Long | Selects |
|------|------|---------|
| `-e` | `--elven` | `ELVEN` (or `ELVEN_RU` with `-c`) |
| `-g` | `--goblin` | `GOBLIN` / `GOBLIN_RU` |
| `-r` | `--roman` | `ROMAN` / `ROMAN_RU` |
| `-k` | `--klingon` | `KLINGON` |
| `-b` | `--belter` | `BELTER` |
| `-x` | `--xrated` | `CURSE` *[NEEDS WORK]* |
| `-d` | `--demonic` | `DEMONIC` |
| `-ß` | `--german-curse` | `GERMAN_CURSE` *[NEEDS WORK]* |
| `-c` | `--cyrillic` | Switches to the Cyrillic branch; alone it means `FANTASY_RU`. |
| `-f` | `--flipmode` | Random language per name; honors `-c`. |
| `-?` | `--help` | Prints the slop usage block. |

With no flags, the default is `FANTASY`.

# Selection semantics

Language selection is a straight run of `if` assignments against a `lang`
variable initialized to `FANTASY`, split into a Cyrillic and a non-Cyrillic
branch. Consequences worth knowing:

- **Last flag in source order wins**, not last on the command line —
  `-e -g` yields Goblin because the `GOBLIN` assignment comes after `ELVEN`.
- The Cyrillic branch only knows Elven, Goblin, and Roman, so `-c -k`,
  `-c -b`, `-c -d` etc. fall through to `FANTASY_RU`.
- `-f` short-circuits language selection entirely; `-?` short-circuits
  everything but `-f`.
- There is **no flag for Welsh** — see the
  [language catalog](/languages/catalog.md).

The CLI exposes no syllable-count option; every name uses
`RandomNameGenerator.pick_number_of_syllables`.

# Packaging

Option parsing uses [slop](https://rubygems.org/gems/slop), which is therefore
a **runtime** dependency of the gem, not merely a Gemfile entry — see
[that decision](/decisions/slop-runtime-dependency.md). The gemspec sets
`bindir = "exe"` and derives `executables` from the tracked files under it.

# Citations

[1] [exe/random_name_generator](https://github.com/folkengine/random_name_generator/blob/main/exe/random_name_generator)
[2] [README — Installation](https://github.com/folkengine/random_name_generator/blob/main/README.md)
