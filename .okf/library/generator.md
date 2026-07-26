---
type: Ruby Class
title: RandomNameGenerator::Generator
description: Reads a syllable file into three buckets and assembles a name by walking prefix → middles → suffix.
resource: https://github.com/folkengine/random_name_generator/blob/main/lib/random_name_generator.rb
tags: [ruby, api, core]
timestamp: 2026-07-26T00:00:00Z
---

The workhorse class. One `Generator` wraps one language file; `compose` may be
called repeatedly on the same instance.

# Construction

```ruby
Generator.new(language = RandomNameGenerator::FANTASY, random: Random.new)
```

`initialize` calls the private `refresh`, which reads every non-blank line of
the language `File`, turns it into a [Syllable](/library/syllable.md), and
pushes it into `@pre_syllables`, `@sur_syllables`, or `@mid_syllables`
according to `prefix?`/`suffix?`. It then rewinds the file handle — necessary
because the language constants are shared open `File` objects
(see [the module](/library/module.md)).

Blank lines are skipped, so a syllable file may be visually grouped by bucket.

# Composition algorithm

`compose_array(count)` returns an array of `Syllable`; `compose(count)` maps it
to strings, joins, and `capitalize`s the result.

1. Sample a prefix from `pre_syllables`.
2. If `count < 2`, return just that prefix — a one-syllable name.
3. Append `count - 2` middles, each chosen from the candidates in
   `mid_syllables` compatible with the syllable before it.
4. Append one suffix from `sur_syllables`, compatible with the last middle.

So a name is always *prefix + (count-2) middles + suffix*, and a two-syllable
name is prefix + suffix with no middle at all. `count` defaults to
`RandomNameGenerator.pick_number_of_syllables`.

Note that `compose` capitalizes the joined string, which in Ruby also
**downcases the remainder** — and `Syllable` already downcases its input, so
generated names are always `Titlecase`.

# Failure mode

`determine_next_syllable` raises `ArgumentError` when no candidate in the
bucket is compatible with the current syllable:

```
No syllable in <path> is compatible with "<syllable>" — check its +v/+c/-v/-c flags
```

This is the practical hazard when authoring a language: over-constrained
adjacency flags, or a bucket too small to satisfy them. `spec/languages/test-incompatible.txt`
is the fixture that pins this behavior. See
[the syllable file format](/formats/syllable-file-format.md).

# Public surface

| Member | Notes |
|--------|-------|
| `#compose(count = …)` | Capitalized `String`. |
| `#compose_array(count = …)` | `Array<Syllable>`. |
| `#language` | The `File` it was built from. |
| `#pre_syllables` / `#mid_syllables` / `#sur_syllables` | The parsed buckets — useful in specs to assert a file loaded as intended. |
| `#to_s` | `"RandomNameGenerator::Generator (goblin.txt)"` — basename only. |

# Examples

```ruby
# Deterministic: seed the injected Random, and pass an explicit count so the
# count itself is not drawn from global randomness.
rng = RandomNameGenerator::Generator.new(RandomNameGenerator::ELVEN, random: Random.new(42))
rng.compose(3)
```

# Citations

[1] [lib/random_name_generator.rb](https://github.com/folkengine/random_name_generator/blob/main/lib/random_name_generator.rb)
