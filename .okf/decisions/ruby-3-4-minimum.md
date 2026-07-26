---
type: Decision
title: Ruby 3.4 is the floor
description: Version 4.0.0 dropped Ruby 3.0–3.3; CI tests 3.4, 4.0, and head.
tags: [decision, ruby, ci]
timestamp: 2026-07-26T00:00:00Z
---

# Decision

`required_ruby_version >= 3.4.0` as of gem version **4.0.0** (2026-07-18).
`.tool-versions` pins the development interpreter to `ruby 3.4.10`, and
RuboCop's `TargetRubyVersion` is `3.4`.

Support for Ruby 3.0 through 3.3 was dropped in the same release, alongside
dependency bumps (`rake ~> 13.4`, `rexml`, `concurrent-ruby`).

# CI matrix

`.github/workflows/ruby.yml` runs the full gate on `3.4`, `4.0`, and `head`.
`head` is `continue-on-error: true` — it exists to catch 4.1 regressions early
without letting a broken nightly red the build. See
[build and test](/development/build-and-test.md).

# Implications

The floor is a hard constraint on new code: 3.4-and-later syntax is fine, and
the four decimal places of `.tool-versions` should track whatever patch the
CI `3.4` job resolves to. Raising the floor again is a **major** version bump.

# Citations

[1] [CHANGELOG.md — 4.0.0](https://github.com/folkengine/random_name_generator/blob/main/CHANGELOG.md)
[2] [.github/workflows/ruby.yml](https://github.com/folkengine/random_name_generator/blob/main/.github/workflows/ruby.yml)
