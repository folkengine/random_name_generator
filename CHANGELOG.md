## Version 4

## 4.0.5 - unreleased

- Added an [OKF](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
  knowledge bundle in `.okf/` — 14 concept files across 6 areas covering the
  Ruby API, the syllable file format, the language catalog, the CLI, the
  development playbooks, and three recorded decisions.
- Expanded `CLAUDE.md` with the project's architecture, conventions, and the
  rules for consulting and maintaining the knowledge bundle.
- Documented the bundle in `README.md`.

## 4.0.4 - 2026-07-19

- Added the Welsh language (`WELSH`), seeded from real Welsh name roots.
  Note: no CLI flag was wired up for it — reachable from the library only.
- Added the Belter language (`BELTER`), the creole from The Expanse, with a
  `-b`/`--belter` CLI flag.
- Both files were generated with the `lang-gen` skill.

## 4.0.3 - 2026-07-19

Fixes from the first full-codebase audit (see [`docs/AUDIT_Fable_5.md`](./docs/AUDIT_Fable_5.md)).

- **`slop` is now a runtime dependency** in the gemspec rather than a Gemfile
  entry, so the installed CLI actually starts.
- **Fixed `compose(1)` crashing**: `compose_array` returns `[@pre]` for counts
  below 2 instead of a `String`, making the return type honest.
- **Fixed blank lines in language files**: `refresh` now strips before the
  empty check.
- **Fixed a potential infinite loop**: `determine_next_syllable` pre-filters
  compatible candidates instead of rejection-sampling, and raises
  `ArgumentError` naming the file and syllable when no candidate exists.
- **Cyrillic and German letters are now classified**: added Cyrillic vowels and
  consonants plus `ö`, `ü`, `ß`, so the `+v`/`+c`/`-v`/`-c` flags in the four
  `*-ru.txt` files and in `german-curse.txt` are actually enforced. They were
  silent no-ops before.
- Fixed the broken `Syllable` clone constructor and a malformed
  `raise ArgumentError`.
- Documented the intentional dual classification of `y` as both vowel and
  consonant.
- Added `spec/languages/test-blank.txt` and `test-incompatible.txt` fixtures,
  plus an adjacency spec that walks composed names pairwise.
- Corrected the README syllable range to "between 2 and 5" and fixed four
  "eyllable" typos.

## 4.0.2 - 2026-07-19

- Added a `-d`/`--demonic` CLI flag for the experimental `DEMONIC` language,
  which had shipped without a way to select it from the command line.
- Added a `-k`/`--klingon` CLI flag for `KLINGON`, likewise unreachable before.

## 4.0.1 - 2026-07-19

- Added the `lang-gen` skill, which generates a fully integrated language from
  a plain-English theme.
- Added the experimental German Curse language (`GERMAN_CURSE`) via `lang-gen`,
  with a `-ß`/`--german-curse` CLI flag.
- Added a portable, LLM-agnostic version of the `lang-gen` prompt in `docs/`.

## 4.0.0 - 2026-07-18

- Raised minimum required Ruby version to 3.4.0 (dropping 3.0–3.3 support).
- Set `.tool-versions` to Ruby 3.4.10.
- Bumped dependencies: `rake` (~> 13.4), `rexml`, `concurrent-ruby`.
- Updated CI workflow and Rubocop settings.

## Version 3

## 3.0.0 - 2024-10-05

- Bumped the major version to mark the removal of Ruby 2.x support.

## Version 2

## 2.1.1 - 2024-10-05

- Added Ruby 3.3.5 to the CI matrix.
- Updated Rubocop settings and applied the resulting style fixes across the
  specs.
- Moved `spec/syllable_spec.rb` to `spec/random_name_generator/syllable_spec.rb`.

## 2.1.0 - 2023-12-17

- Added a devcontainer (`.devcontainer/`) for containerized development.
- Updated the CI workflow and Rubocop settings.
- Refreshed dependencies.

## 2.0.1 - 2021-08-08

- Updated dependencies.

## 2.0.0 - 2021-03-28

- Major Refactor
- Migrated RandomNameGenerator from Class to wrapper module.
- Migrated tests from MiniTest to RSpec.
- Updated license from GPL-3.0 to LGP-L3.0
- Added experimental curse language.
- Moved executable to exe directory.
- Added `bin/run` script to pull in lib directory to gem path.
- Fixed issue with Gemfile.lock created on Apple M1 clashing with GitHub
  Action:
    ```
    $❯ bundle lock --add-platform x86_64-linux
    ```
