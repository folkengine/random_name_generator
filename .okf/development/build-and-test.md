---
type: Playbook
title: Build, test, and lint
description: The commands that gate a change, and what each one enforces.
tags: [development, testing, ci]
timestamp: 2026-07-26T00:00:00Z
---

# The gate

```shell
bundle exec rake        # => spec, then rubocop
```

`rake default` is `%i[spec rubocop]`. Reek is wired as its own task
(`rake reek`, `fail_on_error: true`) but is **not** part of the default task —
run it deliberately.

| Command | Purpose |
|---------|---------|
| `bundle exec rspec` | Tests. One example: `bundle exec rspec spec/random_name_generator_spec.rb:42`. |
| `bundle exec rubocop` | Lint. `-A` to autocorrect. |
| `bundle exec reek` | Smell detection, configured by `config.reek`. |
| `bin/console` | IRB with the gem loaded. |
| `bundle exec rake build` | Builds the `.gem` into `pkg/`. |
| `bundle exec exe/random_name_generator -g` | Run the [CLI](/interfaces/cli.md) from the checkout. |

# Test layout

- `spec/random_name_generator_spec.rb` — module constants, factory methods,
  and `Generator` behavior. Generators for the four base languages are built
  once in a `before(:all)` block.
- `spec/random_name_generator/syllable_spec.rb` — parsing and adjacency rules.
- `spec/languages/*.txt` — fixtures that pin format edges (blank lines, a
  one-syllable-per-bucket file, every flag combination, and an unsatisfiable
  file that must raise). See
  [the syllable file format](/formats/syllable-file-format.md).

`spec_helper.rb` disables RSpec monkey patching, forces `expect` syntax, and
persists example status to `.rspec_status`.

# CI

`.github/workflows/ruby.yml` runs `bundle exec rake` on pushes to `main`,
`v*` tags, and every pull request, against a matrix of Ruby `3.4`, `4.0`, and
`head`. The `head` job is `continue-on-error` — a broken nightly must not red
the run — and installs uncached with the latest bundler, since pairing a fixed
gem cache with a moving interpreter causes `CorruptBundlerInstallError`.

Overcommit hooks are configured in `.overcommit.yml`.

# Citations

[1] [Rakefile](https://github.com/folkengine/random_name_generator/blob/main/Rakefile)
[2] [.github/workflows/ruby.yml](https://github.com/folkengine/random_name_generator/blob/main/.github/workflows/ruby.yml)
