---
type: Decision
title: Randomness is injected, never global
description: Generators take a `random:` keyword so specs can seed them; `srand` and global state are banned.
tags: [decision, testing, api]
timestamp: 2026-07-26T00:00:00Z
---

# Decision

Every sampling point that can be controlled takes an injected `Random`:

```ruby
RandomNameGenerator::Generator.new(lang, random: Random.new(seed))
RandomNameGenerator.pick_number_of_syllables(random: Random.new(seed))
```

`Generator` stores it as `@rnd` and passes it to every `Array#sample` call in
the composition path. Specs that need determinism pass a seeded `Random` —
they never call `srand` or otherwise touch global randomness.

# Why

Global `srand` is process-wide: one spec seeding it changes the behavior of
every later example, and parallel or reordered runs stop being reproducible.
An injected `Random` scopes determinism to the object that needs it.

# Limits

Two entry points remain non-seedable because they sample the *language* with a
bare `Array#sample`: `RandomNameGenerator.flip_mode` and
`.flip_mode_cyrillic`. Their specs assert on type and shape rather than on a
specific name. Also note that `compose` with no argument draws its syllable
count from `pick_number_of_syllables`'s **default** `Random.new` — for a fully
deterministic name, pass the count explicitly.

See [Generator](/library/generator.md) and [the module](/library/module.md).

# Citations

[1] [CLAUDE.md — Conventions](https://github.com/folkengine/random_name_generator/blob/main/CLAUDE.md)
