---
type: Convention
title: Code conventions
description: Style, smell, and testing rules this repo enforces — RuboCop is the source of truth.
tags: [development, style, lint]
timestamp: 2026-07-26T00:00:00Z
---

# RuboCop is the arbiter

`.rubocop.yml` settles style questions; don't relitigate them in review.

| Setting | Value |
|---------|-------|
| `TargetRubyVersion` | 3.4, `NewCops: enable` |
| String literals | **double quotes** (including in interpolation) |
| `Layout/LineLength` | 180 |
| `Metrics/MethodLength` | 11 |
| `Metrics/ClassLength` | disabled |
| `Metrics/BlockLength` | excluded for `spec/**/*` |
| `Style/HashSyntax` | shorthand `either` |

Plugins: `rubocop-rspec`, `rubocop-rake`.

RSpec cops are relaxed where the existing spec style needs it —
`BeforeAfterAll` and `InstanceVariable` are disabled (the specs build shared
generators in `before(:all)`), `MultipleExpectations` is off, and
`NestedGroups` allows 5.

Every source file carries `# frozen_string_literal: true`.

# Reek

`config.reek` disables `IrresponsibleModule` and `TooManyMethods`, caps
instance variables at 10, and caps statements at 8 (excluding `initialize`).
Where a class legitimately exceeds a smell threshold, it carries an inline
`:reek:` annotation rather than a config exemption — e.g. `:reek:TooManyConstants`
on [the module](/library/module.md) and `:reek:TooManyMethods` on
[Syllable](/library/syllable.md).

# Testing

- `expect` syntax only; monkey patching disabled.
- Fixtures live in `spec/languages/`, never inline.
- Never use `srand` or global randomness for determinism — pass a seeded
  `Random`. See [injected randomness](/decisions/injected-randomness.md).

# Shape of the code

Pure file-in / string-out: no network, no threads, no mutable global state
beyond the shared `File` constants. Keeping it that way is what makes the
library trivially embeddable.

# Citations

[1] [.rubocop.yml](https://github.com/folkengine/random_name_generator/blob/main/.rubocop.yml)
[2] [config.reek](https://github.com/folkengine/random_name_generator/blob/main/config.reek)
[3] [CLAUDE.md](https://github.com/folkengine/random_name_generator/blob/main/CLAUDE.md)
