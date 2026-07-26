---
type: Playbook
title: Adding a language
description: The five touch points a new syllable file has to reach, and the lang-gen skill that automates them.
tags: [languages, playbook, contributing]
timestamp: 2026-07-26T00:00:00Z
---

A language is not just a file — it has to be registered, exercised, and
documented. Missing one of these is the usual review comment.

# Steps

1. **Write the `.txt`.** Follow the
   [syllable file format](/formats/syllable-file-format.md). Curated languages
   go in `lib/languages/`; edgy or unpolished ones in
   `lib/languages/experimental/`. Cyrillic variants take the `-ru.txt` suffix.
2. **Register the `File` constant** in `lib/random_name_generator.rb`, grouped
   with its peers (plain / Cyrillic / experimental).
3. **Add a CLI flag** in `exe/random_name_generator` if the language is
   user-facing — both the `o.bool` declaration and the assignment in the
   correct branch of the Cyrillic conditional. See [the CLI](/interfaces/cli.md).
4. **Add a spec** to `spec/random_name_generator_spec.rb`. A smoke test that
   composes names at each syllable count is enough to catch an unsatisfiable
   flag set, which otherwise only surfaces at runtime.
5. **Document it** — README (with a link to the file) and CHANGELOG.

# Verification

Beyond the spec, check that all three buckets are non-empty and that names
actually compose at 1..5 syllables:

```shell
bundle exec ruby -Ilib -e '
  require "random_name_generator"
  g = RandomNameGenerator.new(RandomNameGenerator::WELSH)
  (1..5).each { |n| puts "#{n}: #{Array.new(5) { g.compose(n) }.join(" ")}" }
'
```

Then run the gate: `bundle exec rake` — see
[build and test](/development/build-and-test.md).

# The lang-gen skill

`.claude/skills/lang-gen/SKILL.md` automates the whole flow from a plain-English
theme, e.g. `/lang-gen Klingon words of joy`. It derives the slug, constant,
and destination directory (routing edgy themes to `experimental/`), authors the
three buckets with adjacency flags, performs steps 2–5, and samples names to
verify. `GERMAN_CURSE` was generated this way.

A portable text version of the same prompt lives at
`docs/superpowers/specs/2026-07-19-lang-gen-portable-prompt.md` for use outside
Claude Code.

# Citations

[1] [CLAUDE.md — Adding a language](https://github.com/folkengine/random_name_generator/blob/main/CLAUDE.md)
[2] [README — lang-gen](https://github.com/folkengine/random_name_generator/blob/main/README.md)
