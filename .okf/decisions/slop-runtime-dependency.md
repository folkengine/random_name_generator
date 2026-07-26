---
type: Decision
title: slop is a runtime dependency
description: The CLI ships inside the gem, so its option parser must be in the gemspec — a Gemfile entry is invisible to installed gems.
tags: [decision, packaging, cli]
timestamp: 2026-07-26T00:00:00Z
---

# Decision

`slop ~> 4.10` is declared with `spec.add_dependency` in
`random_name_generator.gemspec`, not merely in the `Gemfile`.

# Why

`exe/random_name_generator` ships as a gem executable and does
`require "slop"` at the top. A `Gemfile` entry only affects development in
this checkout; it is not carried into the published gem. Without the gemspec
dependency, `gem install random_name_generator` followed by
`random_name_generator -g` fails with `LoadError` on a machine that happens
not to have slop.

The gemspec carries an inline comment saying exactly this, so the classification
survives future dependency cleanups.

# Scope

This applies to anything the shipped [CLI](/interfaces/cli.md) or `lib/`
requires at runtime. Test and lint tooling (rspec, rubocop, reek, rake) stays
in the Gemfile — those are correctly development-only.

# Citations

[1] [random_name_generator.gemspec](https://github.com/folkengine/random_name_generator/blob/main/random_name_generator.gemspec)
