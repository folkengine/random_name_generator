---
type: Ruby Module
title: RandomNameGenerator (module)
description: Top-level facade — holds one File constant per language, factory methods, and the syllable-count distribution.
resource: https://github.com/folkengine/random_name_generator/blob/main/lib/random_name_generator.rb
tags: [ruby, api, entrypoint]
timestamp: 2026-07-26T00:00:00Z
---

`RandomNameGenerator` is a module, not a class. It exists to (a) name every
bundled syllable file as a constant, and (b) act as a static factory for
[Generator](/library/generator.md), which does the actual work.

# Language constants

Each language is an **open `File` object** created at load time from
`lib/languages/`, not a path string:

```ruby
GOBLIN = File.new("#{dirname}/languages/goblin.txt")
```

That has two consequences worth knowing: the file handles are opened when the
module is required, and `Generator#refresh` must `rewind` the handle after
reading so a second `Generator` on the same constant still sees content. See
the [language catalog](/languages/catalog.md) for the full list.

# API

| Method | Purpose |
|--------|---------|
| `RandomNameGenerator.new(language = FANTASY, random: Random.new)` | Static factory returning a `Generator`. Not a constructor — the module has no instances. |
| `RandomNameGenerator.flip_mode` | `Generator` over a random pick of `FANTASY`, `ELVEN`, `GOBLIN`, `ROMAN`. |
| `RandomNameGenerator.flip_mode_cyrillic` | Same, over the four `*_RU` constants. |
| `RandomNameGenerator.pick_number_of_syllables(random: Random.new)` | Samples the default syllable count. |

`flip_mode` and `flip_mode_cyrillic` take no `random:` keyword — they use
`Array#sample` with global randomness for the language pick, so they are not
seedable. Only `.new` and `pick_number_of_syllables` accept an injected
`Random`; see [injected randomness](/decisions/injected-randomness.md).

# Syllable-count distribution

`pick_number_of_syllables` samples from a literal weighted array rather than
computing a distribution:

```ruby
[2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5]
```

That is 4/18 twos, 10/18 threes, 3/18 fours, 1/18 fives — three-syllable names
are the common case by design.

# Examples

```ruby
require "random_name_generator"

rng = RandomNameGenerator.new(RandomNameGenerator::GOBLIN)
puts rng.compose(3)

flip = RandomNameGenerator.flip_mode
puts flip.compose
```

# Citations

[1] [lib/random_name_generator.rb](https://github.com/folkengine/random_name_generator/blob/main/lib/random_name_generator.rb)
[2] [README — Usage](https://github.com/folkengine/random_name_generator/blob/main/README.md)
