# CLAUDE.md

## Project

`random_name_generator` — a Ruby gem (Ruby 3.4.10) that builds names by assembling
syllables from per-language `.txt` files. Ships a library API and a `slop`-based CLI
(`exe/random_name_generator`).

## Commands

- **Full check (the gate):** `bundle exec rake` — runs `spec` then `rubocop`.
- **Tests:** `bundle exec rspec` — one line: `bundle exec rspec spec/random_name_generator_spec.rb:42`
- **Lint:** `bundle exec rubocop` (auto-fix `-A`) · **Smells:** `bundle exec reek`
- **Console:** `bin/console` · **Build:** `bundle exec rake build`
- **Run CLI:** `bundle exec exe/random_name_generator -g`

## Architecture

- `lib/random_name_generator.rb` — the module. Each language is a `File` constant, e.g.
  `GOBLIN = File.new(".../goblin.txt")`. `Generator` reads it and composes a name.
- `lib/random_name_generator/syllable.rb` — parses one line: `-` = first, `+` = last,
  else middle; `+v/+c/-v/-c` are vowel/consonant adjacency rules (see class doc).
- `lib/languages/*.txt` — the domain data: plain, Cyrillic (`*-ru.txt`), `experimental/`.
- `exe/random_name_generator` — CLI; flags (`-e/-g/-r/-k/-b/-c/-x/-d/-ß`) pick a constant.

## Conventions

- **Randomness is injected:** `Generator.new(lang, random: Random.new)`. For deterministic
  specs pass a seeded `Random.new(seed)` — never `srand` or global state.
- **`slop` is a runtime dep** (in the gemspec, not just the Gemfile) — the installed CLI needs it.
- **RuboCop is source of truth** (`.rubocop.yml`): double quotes, LineLength 180, MethodLength 11.
  RSpec: `expect` only. Test fixtures live in `spec/languages/`.
- Pure file-in/string-out: no network, no threads.

## Adding a language

`.txt` file → `File` constant → CLI flag (if user-facing) → spec → README + CHANGELOG.
The `lang-gen` skill automates this.

## Knowledge bundle

`.okf/` is an [OKF](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
bundle (markdown + YAML frontmatter) carrying the detail this file compresses: the
syllable-file grammar, per-language bucket counts, CLI selection quirks, and the
reasoning behind the conventions above. Start at `.okf/index.md`.

- **Consult it** before changing the composition algorithm, the syllable format, or the CLI.
- **Maintain it:** when a change invalidates a concept, update that file's body and
  `timestamp`, then append a dated entry to `.okf/log.md`. The `okf` skill covers the flow.
