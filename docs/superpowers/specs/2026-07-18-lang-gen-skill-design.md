# `/lang-gen` skill — design

**Date:** 2026-07-18
**Status:** Approved, pending implementation plan

## Context

`random_name_generator` composes fake names from small language files under
`lib/languages/`. Each file is a tiny DSL:

- One syllable per line.
- Leading `-` → **prefix** (pre) bucket; leading `+` → **suffix** (sur) bucket;
  no leading sign → **middle** (mid) bucket. `Generator#push` reads these.
- Trailing flags encode phonotactics, per `lib/random_name_generator/syllable.rb`:
  - `+v` — next syllable must start with a vowel.
  - `+c` — next syllable must start with a consonant.
  - `-v` — this syllable may only follow one ending in a vowel.
  - `-c` — this syllable may only follow one ending in a consonant.

Adding a language today is a manual two-step: drop a `.txt` in `lib/languages/`
(edgy themes go in `lib/languages/experimental/`, like `curse.txt`), then wire a
`File.new(...)` constant into `lib/random_name_generator.rb`.

`/lang-gen` automates this as a **guided authoring skill**: turn a free-text
theme into a well-flagged syllable file plus its integration.

## Goal

`/lang-gen <free text theme>` (e.g. `/lang-gen german curse words`) produces a
new, ready-to-use language: a syllable `.txt`, a registered constant, a smoke
spec, a README entry, and sample output for a quality check.

## Decisions (from brainstorming)

| Question | Decision |
|----------|----------|
| Output scope | **Full integration** — `.txt` + constant + README entry + smoke spec |
| File destination | **experimental/ for edgy themes**; tame themes → `lib/languages/` |
| Skill location | **Project** `.claude/skills/lang-gen/SKILL.md`, committed |
| Linguistic method | **Hybrid** — seed from real roots, then extend with same-flavor invented syllables |
| Size & flags | **Match existing files** (~20–40 per bucket) **+ smart flags** |
| Verification | **Sample and show** ~10 composed names + parse-check |

## Design

### Trigger and argument parsing

- Invoked as `/lang-gen <free text theme>`. The whole argument string is the theme.
- Derive:
  - **slug** — concise kebab-case, 1–2 meaningful words, dropping filler
    ("words", "generator", articles). `german curse words` → `german-curse`.
  - **constant** — SCREAMING_SNAKE of the slug. `german-curse` → `GERMAN_CURSE`.
  - **destination** — edgy/NSFW/joke themes (curse, insult, swear, drunk, etc.)
    → `lib/languages/experimental/`; otherwise `lib/languages/`.
- Show the derived slug / constant / destination and **confirm with the user**
  before writing, so they can rename or re-route.
- Guard against collisions: if the slug file or constant already exists, stop and
  ask (do not overwrite an existing language).

### Syllable generation (hybrid, seeded-then-extended)

The skill body instructs Claude to:

1. Recall a handful of **real theme roots** appropriate to the theme
   (German curses: `schei`, `arsch`, `sau`, `verdammt`, `dreck`, `mist`, …).
2. Slot fragments into the three buckets:
   - prefixes (`-`) — natural word beginnings,
   - middles (bare) — connective interior fragments,
   - suffixes (`+`) — natural word endings / intensifiers.
3. **Pad** each bucket with same-flavor **invented** syllables until each holds
   roughly **20–40** entries, matching `goblin.txt` scale.
4. Apply `+v/+c/-v/-c` flags where they prevent awkward clusters, following the
   exact semantics in `syllable.rb` (e.g. a consonant-final prefix that would
   clash gets a flag; a lone vowel-ending fragment gets `+c`). Flags are used
   judiciously, not on every line.

### Full integration

After the `.txt` is written:

- **Constant** — add `CONST = File.new("#{dirname}/languages/<path>")` to
  `lib/random_name_generator.rb`. Edgy themes go under the existing
  `# Experimental` block; tame themes alongside the curated constants. The
  curated `flip_mode` arrays are **not** modified (they stay hand-picked).
- **Spec** — add a minimal RSpec smoke test following existing `spec/`
  conventions: the file loads, parses, all three buckets are non-empty, and
  `compose` returns a non-empty String.
- **README** — add the new language under a short experimental-languages note
  (link to the file), consistent with how the curated four are listed.

### Verification (sample and show)

Before declaring done, the skill:

- **Parse-checks**: every line is a valid syllable; pre, mid, and sur buckets are
  all non-empty.
- **Samples**: loads the new constant through the gem and prints ~10 names via
  `RandomNameGenerator.new(RandomNameGenerator::CONST).compose`.
- If output looks broken or monotonous, it iterates on the syllable file before
  finishing.

### Skill packaging

- Lives at `.claude/skills/lang-gen/SKILL.md` with YAML frontmatter
  (`name`, `description`, trigger guidance).
- Per the project rule, add a link to `README.md` under a `## Skills` section
  using the skill's `name` as link text and its `description` as the blurb.

## Constraints / notes

- **Git is manual.** State-changing git is off-limits to the assistant; the
  spec-commit and final commit are surfaced as suggested commands for the user
  to run, not executed by the skill.
- **No overwrite.** The skill never clobbers an existing language file or
  constant without explicit confirmation.

## Out of scope (YAGNI)

- Editing `flip_mode` / `flip_mode_cyrillic` sampler arrays.
- Cyrillic (`-ru`) variants of generated languages.
- Bulk / batch generation of multiple themes at once.
- Programmatic scraping of external wordlists.
