# random_name_generator Repository Audit — Claude Fable 5

_Date:_ 2026-07-19
_Repo:_ `random_name_generator` v4.0.2 (working tree, including the in-flight Demonic language and CLI additions)
_Model:_ Claude Fable 5 (`claude-fable-5`)
_Audit basis:_ Full codebase read + empirical verification — every defect below was reproduced with a live repro before being reported.

> **Remediation:** all nine findings were fixed on 2026-07-19, immediately following
> this audit, with regression specs added for each (suite grew from 61 to 168
> examples). The findings below describe the codebase as audited.

---

## Executive Summary

`random_name_generator` is a small, clean, dependency-light gem that does what it says: green test suite (61 examples, 0 failures), RuboCop clean at repo settings (11 files, no offenses), no runtime gem dependencies, and a simple two-class core (`Generator`, `Syllable`) that is easy to hold in your head.

The audit found **3 high-severity defects** — one packaging, two runtime — and a cluster of medium/low issues concentrated in `Syllable`'s letter classification and error paths. None affect the happy path exercised by the specs, which is precisely why they have survived: the suite tests that names compose, not what happens at the edges.

| # | Finding | Severity | Effort to fix |
|---|---------|----------|---------------|
| 1 | CLI requires `slop`, but the gemspec declares no runtime dependency on it | High | Low |
| 2 | `compose(1)` crashes (`String#map`) despite documented single-syllable support | High | Low |
| 3 | Unsatisfiable adjacency flags hang the process in an infinite loop | High | Medium |
| 4 | Blank line in a language file crashes `Generator#refresh` | Medium | Low |
| 5 | Documented `Syllable` clone constructor crashes | Medium | Low |
| 6 | Cyrillic letters are in neither letter set — all flags in the four `-ru` files are silent no-ops | Medium | Medium |
| 7 | Empty-syllable guard is doubly broken (unreachable + malformed `raise`) | Low | Low |
| 8 | `y` classified as both vowel and consonant | Low | Low |
| 9 | Documentation drift on syllable-count range (README vs code vs spec) | Low | Low |

---

## Scope and Method

**Verified by direct read (complete files):**

- `lib/random_name_generator.rb`
- `lib/random_name_generator/syllable.rb`
- `lib/random_name_generator/version.rb`
- `exe/random_name_generator`
- `spec/random_name_generator_spec.rb` and both spec fixture languages
- `random_name_generator.gemspec`, `Gemfile`, `Rakefile`
- `.github/workflows/ruby.yml`
- All 13 language files (curated, `-ru`, and experimental)

**Verified empirically:** every High/Medium finding was reproduced by executing the failing call under the bundle, including a `Timeout`-guarded repro for the infinite loop and a crafted two-line language file for the blank-line crash (which was also hit organically during this session, completing the WIP `demonic.txt`).

**Health signals:**

- `bundle exec rspec`: **61 examples, 0 failures**
- `bundle exec rubocop`: **11 files inspected, no offenses**
- `bundle exec rake` (default: spec + rubocop): green
- Runtime dependencies: none declared (see Finding 1 for the catch)

---

## Findings

### 1. Missing runtime dependency: the installed CLI cannot start (High)

`exe/random_name_generator` line 6 does `require "slop"`, but `slop` is declared only in the **Gemfile** (`gem "slop", "~> 4.10.1"`), which end users never see. The gemspec's dependency section is an empty template comment.

Consequence: after `gem install random_name_generator`, running `random_name_generator` raises `LoadError: cannot load such file -- slop` on any machine that doesn't coincidentally have slop installed. Every CI run and local dev invocation goes through Bundler, so this is invisible to the test suite by construction.

**Fix (low effort):** add `spec.add_dependency "slop", "~> 4.10"` to the gemspec and remove it from the Gemfile.

### 2. `compose(1)` crashes despite documented support (High)

`syllable.rb`'s header documentation states: *"In case of 1 syllable, name will be chosen from amongst the prefixes."* The code disagrees:

- `Generator#compose_array` (`lib/random_name_generator.rb:89`) returns a **String** (`@pre.to_s.capitalize`) when `count < 2`, an Array otherwise.
- `Generator#compose` (`lib/random_name_generator.rb:97`) unconditionally calls `.map` on that result.

Repro: `RandomNameGenerator.new(ELVEN).compose(1)` → `NoMethodError: undefined method 'map' for an instance of String`.

The type-splitting return also makes `compose_array(1)` a misnomer — callers get a String from a method named `_array`. **Fix:** have `compose_array` return `[@pre]` for `count < 2`; both bugs disappear and the return type becomes honest.

### 3. Unsatisfiable flag combinations hang the process (High)

`Generator#determine_next_syllable` (`lib/random_name_generator.rb:126-133`) is a bare `loop` that resamples until it draws a compatible syllable. If **no** syllable in the target bucket is compatible, it spins forever.

Repro (hangs, killed by timeout): a language whose only prefix is `-ba +v` (next must start with a vowel) and whose only suffix is `+kar`. Since the README explicitly invites users to supply their own syllable files, this is reachable input, not just an authoring mistake — one bad file freezes the host application with no diagnostic.

**Fix (medium effort):** track attempts (or pre-filter the bucket by compatibility) and raise a descriptive error when no compatible syllable exists.

### 4. Blank lines in language files crash loading (Medium)

`Generator#refresh` (`lib/random_name_generator.rb:138`) guards with `line.empty?`, but lines from `readlines` retain `"\n"`, so the guard never fires; `Syllable#parse_args` then splits the whitespace-only string into `[]` and calls `nil.empty?` (`syllable.rb:137`) → `NoMethodError`.

This is not hypothetical: the committed WIP `demonic.txt` used blank lines as bucket separators and crashed on load — likely part of why that file sat unfinished. **Fix:** `line.strip.empty?` in `refresh` (one word), or skip whitespace-only lines in `Syllable`.

### 5. Documented `Syllable` clone constructor crashes (Medium)

The `Syllable` header advertises `Syllable.new(syllable)` as a cloning idiom, and `initialize` has an explicit `args.is_a?(Syllable)` branch for it (`syllable.rb:56-60`). But line 49 — `@raw = args.strip` — executes first, and `Syllable` defines no `strip`.

Repro: `Syllable.new(Syllable.new("-foo +c"))` → `NoMethodError: undefined method 'strip' for an instance of RandomNameGenerator::Syllable`. The clone path is dead code; nothing in the gem or specs exercises it. **Fix:** `@raw = args.to_s.strip` (Syllable already implements `to_s`), plus a spec.

### 6. Adjacency flags are silent no-ops for Cyrillic (Medium)

`Syllable::VOWELS` and `CONSONANTS` (`syllable.rb:45-46`) contain only Latin/IPA characters. For a Cyrillic syllable, `vowel_first?`, `consonant_first?`, `vowel_last?`, and `consonant_last?` are all **false** (verified: `-анг` reports neither vowel- nor consonant-final).

Consequence: in `next_incompatible?`/`previous_incompatible?`, nothing can ever be incompatible, so every `+v/+c/-v/-c` flag in the four `-ru` language files — and all four carry them — is dead weight. Names still generate; they just ignore constraints the language authors wrote, silently. **Fix:** add Cyrillic vowels (а е ё и о у ы э ю я) and consonants to the sets, or classify by Unicode-aware rules.

### 7. The empty-syllable guard is doubly broken (Low)

`syllable.rb:137`: `raise ArgumentError "Empty String is not allowed." if syll.empty?`

- **Unreachable as intended:** an empty or whitespace input produces `args[0] == nil`, so `syll.empty?` raises `NoMethodError` on `nil` before the guard can act (this is the crash surfacing in Findings 4 and the `Syllable.new("")` repro).
- **Malformed if it were reached:** the missing comma means `ArgumentError "…"` is parsed as a method call, which would itself raise `NoMethodError`, not the intended `ArgumentError`.

**Fix:** `raise ArgumentError, "…" if syll.nil? || syll.empty?`.

### 8. `y` is both a vowel and a consonant (Low)

`y` appears in both letter sets, so `+v` and `+c` flags each accept y-initial syllables. Linguistically defensible for a semivowel, but it's undocumented and asymmetric (no other letter is dual-classified). Worth a comment if intentional.

### 9. Documentation drift on syllable counts (Low)

Three sources disagree with the code (`pick_number_of_syllables` samples from a weighted 2–5 distribution):

- README: "it will randomly pick between 3 and 6"
- Module doc in `random_name_generator.rb`: "between 2 and 5" ✓ (correct)
- Spec title: "returns an integer between 1 and 6" (assertion actually checks 1..5)

Also cosmetic: the CLI help text spells "syllable" as "eyllable" in four option descriptions.

---

## Test Coverage Assessment

The suite is a smoke suite: it proves every bundled language loads and composes, and that syllable counts come out right. It does **not** cover:

- Adjacency-flag semantics (no spec would catch Finding 6 — the flags could be deleted entirely and the suite stays green)
- Any error path (Findings 2, 4, 5, 7 are all crashes in paths with zero coverage)
- The CLI (`exe/` has no test at all; Finding 1 ships silently)

The fixture languages (`test-micro.txt`, `test-tiny.txt`) are well-designed for flag testing — `test-tiny.txt` deliberately exercises every flag combination — but no assertion actually inspects flag behavior.

---

## Recommendations (priority order)

1. **Gemspec:** declare the `slop` runtime dependency. One line; unbreaks the installed CLI.
2. **`compose_array`:** return `[@pre]` for `count < 2`. Fixes `compose(1)` and the return-type lie.
3. **`refresh`:** strip lines before the empty check. Fixes blank-line crashes and makes hand-authored files forgiving.
4. **`determine_next_syllable`:** bound the retry loop with a clear error. Turns a hang into a diagnosis.
5. **Letter sets:** add Cyrillic ranges so the `-ru` flags do what their authors intended; add a flag-behavior spec pinned to `test-tiny.txt`.
6. **Cleanups:** fix the `raise` syntax and clone constructor, correct the README/spec-title ranges, fix "eyllable".

None of these threaten the gem's architecture, which is sound for its size. The pattern across all findings is the same: the edges were never walked. A dozen targeted specs would lock in every fix above.
