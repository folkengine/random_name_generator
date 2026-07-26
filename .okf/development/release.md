---
type: Playbook
title: Releasing the gem
description: Version bump, changelog, and the rake release path to RubyGems.
resource: https://rubygems.org/gems/random_name_generator
tags: [development, release, packaging]
timestamp: 2026-07-26T00:00:00Z
---

The gem is published as
[random_name_generator](https://rubygems.org/gems/random_name_generator) under
LGPL-3.0. Current version: **4.0.4** (`lib/random_name_generator/version.rb`).

# Steps

1. Bump `RandomNameGenerator::VERSION` in `lib/random_name_generator/version.rb`
   — the gemspec reads it, so it is the single source of truth.
2. Add a CHANGELOG entry under a `## <version> - <YYYY-MM-DD>` heading.
3. Run the gate: `bundle exec rake` (see
   [build and test](/development/build-and-test.md)).
4. `bundle exec rake release` — tags, pushes commits and the tag, and pushes
   the `.gem` to RubyGems. Pushing a `v*` tag also triggers CI.

`rubygems_mfa_required` is set in the gemspec metadata, so the push requires
MFA.

# Packaging notes

- `spec.files` comes from `git ls-files`, minus `test/`, `spec/`, and
  `features/` — an untracked language file will **not** ship.
- `bindir` is `exe`; executables are derived from tracked files there.
- `required_ruby_version >= 3.4.0` — see
  [the Ruby floor](/decisions/ruby-3-4-minimum.md).
- `slop ~> 4.10` is a runtime dependency, not a development one — see
  [why](/decisions/slop-runtime-dependency.md).

`bundle exec rake install` installs the gem locally, which is how you get a
bare `random_name_generator` command on `PATH` for testing the
[CLI](/interfaces/cli.md).

# Citations

[1] [random_name_generator.gemspec](https://github.com/folkengine/random_name_generator/blob/main/random_name_generator.gemspec)
[2] [CHANGELOG.md](https://github.com/folkengine/random_name_generator/blob/main/CHANGELOG.md)
