# /lang-gen Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a project-local `/lang-gen` skill that turns a free-text theme (e.g. "german curse words") into a fully integrated `random_name_generator` language.

**Architecture:** The deliverable is a single prose skill file, `.claude/skills/lang-gen/SKILL.md`, that instructs Claude through a fixed workflow: parse the theme → derive slug/constant/destination → author a flagged syllable `.txt` (hybrid seeded-then-extended method) → register the constant → add a smoke spec and README entry → verify by parse-check and by sampling composed names. The skill is registered in the project README. A final end-to-end task exercises the skill against "german curse words" to prove it works.

**Tech Stack:** Markdown + YAML frontmatter (skill), Ruby 3.4+ / RSpec (the gem under test), the language-file DSL defined in `lib/random_name_generator/syllable.rb`.

## Global Constraints

- **Language-file DSL (verbatim from `syllable.rb`):** one syllable per line; leading `-` = prefix bucket, leading `+` = suffix bucket, no sign = middle bucket. Flags: `+v` next-must-start-vowel, `+c` next-must-start-consonant, `-v` this-follows-vowel-ending, `-c` this-follows-consonant-ending. Order of flags is not significant; separated by whitespace.
- **Bucket sizing:** ~20–40 syllables per bucket (pre / mid / sur), matching `lib/languages/goblin.txt`.
- **Edgy-theme routing:** curse/insult/swear/NSFW/drunk themes → `lib/languages/experimental/`; tame themes → `lib/languages/`.
- **Git is manual:** the assistant must NOT run any state-changing git command. Every "Commit" step below is a **suggested command surfaced to the user to run themselves**, never executed by the assistant. This applies inside the skill too.
- **No overwrite:** never clobber an existing language file or `File.new` constant without explicit user confirmation.
- **flip_mode arrays are hand-curated:** do NOT add generated languages to `flip_mode` / `flip_mode_cyrillic`.
- **README Skills rule (project convention):** when a skill is added, link it in `README.md` under `## Skills` using the skill's `name` as link text and its `description` as the blurb.

---

### Task 1: Author the `/lang-gen` SKILL.md

**Files:**
- Create: `.claude/skills/lang-gen/SKILL.md`

**Interfaces:**
- Produces: a skill named `lang-gen`, invocable via `/lang-gen <theme>`, discoverable in the skills list. No code symbols.

- [ ] **Step 1: Create the skill file with frontmatter and full workflow**

Create `.claude/skills/lang-gen/SKILL.md` with exactly this content:

````markdown
---
name: lang-gen
description: Generate a new random_name_generator language from a free-text theme (e.g. "german curse words") — assembles flagged pre/mid/sur syllable collections, registers the File constant, adds a smoke spec and README entry, and samples names to verify. Use when the user types /lang-gen or asks to create, generate, or add a new language, dialect, or syllable file for the name generator.
---

# lang-gen

Turn a free-text theme into a fully integrated `random_name_generator`
language file. Invoked as `/lang-gen <theme>`, e.g. `/lang-gen german curse words`.

## The language-file DSL

Authoritative source: `lib/random_name_generator/syllable.rb`. Each line of a
language `.txt` is one syllable:

- Leading `-` → **prefix** (pre) bucket — a name beginning.
- Leading `+` → **suffix** (sur) bucket — a name ending.
- No sign → **middle** (mid) bucket — an interior fragment.

Optional whitespace-separated flags after the syllable constrain adjacency:

- `+v` — the NEXT syllable must start with a vowel.
- `+c` — the NEXT syllable must start with a consonant.
- `-v` — THIS syllable may only follow one ending in a vowel.
- `-c` — THIS syllable may only follow one ending in a consonant.

A name needs all three buckets non-empty. `Generator#compose` picks a prefix,
fills with middles, ends with a suffix, honoring the flags.

## Workflow

Follow these steps in order. Do not skip verification.

### 1. Parse the theme and derive names

From the argument string derive and then **show the user for confirmation**:

- **slug** — concise kebab-case, 1–2 meaningful words, drop filler ("words",
  "generator", articles). `german curse words` → `german-curse`.
- **constant** — SCREAMING_SNAKE of the slug. `german-curse` → `GERMAN_CURSE`.
- **destination** — edgy themes (curse, insult, swear, NSFW, drunk, etc.) →
  `lib/languages/experimental/<slug>.txt`; tame themes →
  `lib/languages/<slug>.txt`.

Before writing anything, check for collisions: if the target `.txt` OR the
constant already exists, STOP and ask the user how to proceed. Never overwrite.

### 2. Author the syllable file (hybrid: seed, then extend)

1. Recall a handful of **real roots** for the theme. (German curses: `schei`,
   `arsch`, `sau`, `verdammt`, `dreck`, `mist`, `depp`, `blöd`, …)
2. Slot fragments into buckets: prefixes (`-`) = natural beginnings, middles
   (bare) = connective interiors, suffixes (`+`) = natural endings / intensifiers.
3. **Extend** each bucket with same-flavor **invented** syllables until each
   holds ~20–40 entries (match `lib/languages/goblin.txt` scale).
4. Add `+v/+c/-v/-c` flags **only where they prevent awkward clusters** — e.g. a
   consonant-final prefix that would collide, or a lone vowel that reads badly
   after another vowel. Most lines carry no flag. Keep it judicious.

Write the file to the destination from step 1.

### 3. Register the constant

Edit `lib/random_name_generator.rb`. Add, next to the matching group of
constants (edgy → under the `# Experimental` comment; tame → with the curated
constants):

```ruby
CONSTANT_NAME = File.new("#{dirname}/languages/<relative/path>.txt")
```

Do NOT touch `flip_mode` or `flip_mode_cyrillic` — those arrays are curated.

### 4. Add a smoke spec

Add an example to `spec/random_name_generator_spec.rb` following existing
conventions (see the `with languages` context). It must assert the constant is a
`File`, its `path` includes the expected filename, and that a `Generator` built
from it composes a non-empty `String`:

```ruby
it "when it has a <Theme> language" do
  expect(RandomNameGenerator::CONSTANT_NAME).to be_a(File)
  expect(RandomNameGenerator::CONSTANT_NAME.path).to include("languages/<relative/path>.txt")
  name = RandomNameGenerator::Generator.new(RandomNameGenerator::CONSTANT_NAME).compose
  expect(name).to be_a(String)
  expect(name).not_to be_empty
end
```

### 5. Add a README entry

Add the new language to `README.md`. Edgy/experimental languages go under a
short "Experimental languages" note; tame ones join the curated list. Link to
the file, matching how the curated four are listed.

### 6. Verify — parse-check then sample

- **Parse-check:** confirm every line is a valid syllable and all three buckets
  are non-empty. Fastest via the gem:

  ```bash
  bundle exec ruby -Ilib -rrandom_name_generator -e '
    g = RandomNameGenerator::Generator.new(RandomNameGenerator::CONSTANT_NAME)
    abort "empty pre"  if g.pre_syllables.empty?
    abort "empty mid"  if g.mid_syllables.empty?
    abort "empty sur"  if g.sur_syllables.empty?
    puts "buckets OK: #{g.pre_syllables.size}/#{g.mid_syllables.size}/#{g.sur_syllables.size}"
  '
  ```

- **Sample:** print ~10 composed names for the user to eyeball:

  ```bash
  bundle exec ruby -Ilib -rrandom_name_generator -e '
    g = RandomNameGenerator::Generator.new(RandomNameGenerator::CONSTANT_NAME)
    10.times { puts g.compose }
  '
  ```

- **Run the spec:** `bundle exec rspec spec/random_name_generator_spec.rb`

If names look broken or monotonous, iterate on the `.txt` (more variety, better
flags) and re-sample before finishing.

### 7. Hand off the commit

Git is manual. Do NOT run git yourself. Surface the exact command for the user:

```bash
git add lib/languages README.md lib/random_name_generator.rb spec/random_name_generator_spec.rb && git commit -m "Add <Theme> language via /lang-gen"
```

## Guardrails

- Never overwrite an existing language file or constant without confirmation.
- Never run state-changing git commands — always suggest them.
- Keep bucket sizes and flag style consistent with existing `lib/languages/*.txt`.
````

- [ ] **Step 2: Verify the skill file is structurally valid**

Run:

```bash
head -5 .claude/skills/lang-gen/SKILL.md && echo "---" && grep -c '^### [1-7]\.' .claude/skills/lang-gen/SKILL.md
```

Expected: the frontmatter shows `name: lang-gen` and the `description:` line; the grep prints `7` (all seven workflow steps present).

- [ ] **Step 3: Commit (suggest to user — do not run)**

Surface this command for the user:

```bash
git add .claude/skills/lang-gen/SKILL.md && git commit -m "Add /lang-gen skill"
```

---

### Task 2: Register the skill in the project README

**Files:**
- Modify: `README.md`

**Interfaces:**
- Consumes: the `name` (`lang-gen`) and `description` authored in Task 1.
- Produces: a `## Skills` section linking the skill, satisfying the project's README rule.

- [ ] **Step 1: Add the Skills section**

Append a `## Skills` section to `README.md` (place it before the license footer). Use exactly:

```markdown
## Skills

- [lang-gen](.claude/skills/lang-gen/SKILL.md) — Generate a new random_name_generator language from a free-text theme (e.g. "german curse words") — assembles flagged pre/mid/sur syllable collections, registers the File constant, adds a smoke spec and README entry, and samples names to verify.
```

- [ ] **Step 2: Verify the link and file line up**

Run:

```bash
grep -n '^## Skills' README.md && test -f .claude/skills/lang-gen/SKILL.md && echo "target exists"
```

Expected: prints the `## Skills` line number and `target exists`.

- [ ] **Step 3: Commit (suggest to user — do not run)**

Surface this command for the user:

```bash
git add README.md && git commit -m "Register /lang-gen in README Skills section"
```

---

### Task 3: End-to-end validation — generate the `german-curse` language

This task runs the finished skill against the motivating example to prove the
whole workflow produces working output. It is the plan's integration test.

**Files (produced by running the skill):**
- Create: `lib/languages/experimental/german-curse.txt`
- Modify: `lib/random_name_generator.rb` (add `GERMAN_CURSE` constant under `# Experimental`)
- Modify: `spec/random_name_generator_spec.rb` (add German-curse smoke example)
- Modify: `README.md` (experimental-languages note)

**Interfaces:**
- Consumes: the `.claude/skills/lang-gen/SKILL.md` workflow from Task 1.
- Produces: `RandomNameGenerator::GERMAN_CURSE` — a `File` at `languages/experimental/german-curse.txt`, usable via `RandomNameGenerator::Generator.new(RandomNameGenerator::GERMAN_CURSE)`.

- [ ] **Step 1: Invoke the skill**

Run `/lang-gen german curse words` and follow the SKILL.md workflow. Confirm the
derived slug `german-curse`, constant `GERMAN_CURSE`, destination
`lib/languages/experimental/german-curse.txt`.

- [ ] **Step 2: Verify buckets parse and are non-empty**

Run:

```bash
bundle exec ruby -Ilib -rrandom_name_generator -e '
  g = RandomNameGenerator::Generator.new(RandomNameGenerator::GERMAN_CURSE)
  abort "empty pre" if g.pre_syllables.empty?
  abort "empty mid" if g.mid_syllables.empty?
  abort "empty sur" if g.sur_syllables.empty?
  puts "buckets OK: #{g.pre_syllables.size}/#{g.mid_syllables.size}/#{g.sur_syllables.size}"
'
```

Expected: `buckets OK: N/N/N` with each N in roughly 20–40.

- [ ] **Step 3: Sample names**

Run:

```bash
bundle exec ruby -Ilib -rrandom_name_generator -e '
  g = RandomNameGenerator::Generator.new(RandomNameGenerator::GERMAN_CURSE)
  10.times { puts g.compose }
'
```

Expected: 10 varied, pronounceable, German-flavored strings. If monotonous or broken, iterate on the `.txt` and repeat.

- [ ] **Step 4: Run the full test suite**

Run: `bundle exec rspec`

Expected: all examples pass, including the new German-curse smoke example.

- [ ] **Step 5: Commit (suggest to user — do not run)**

Surface this command for the user:

```bash
git add lib/languages/experimental/german-curse.txt lib/random_name_generator.rb spec/random_name_generator_spec.rb README.md && git commit -m "Add German curse language via /lang-gen"
```

---

## Self-Review

**Spec coverage:**
- Trigger & arg parsing → Task 1 §1. ✓
- Slug/constant/destination derivation + confirm → Task 1 §1. ✓
- Edgy-theme routing → Task 1 §1 + Global Constraints. ✓
- Collision guard / no overwrite → Task 1 §1 + Guardrails. ✓
- Hybrid seeded-then-extended generation → Task 1 §2. ✓
- ~20–40 per bucket + smart flags → Task 1 §2 + Global Constraints. ✓
- Constant registration, flip_mode untouched → Task 1 §3. ✓
- Smoke spec → Task 1 §4. ✓
- README language entry → Task 1 §5. ✓
- Verification: parse-check + sample → Task 1 §6, exercised in Task 3. ✓
- Git manual → Global Constraints + every commit step + Task 1 §7. ✓
- Skill location `.claude/skills/lang-gen/` → Task 1. ✓
- README `## Skills` registration → Task 2. ✓

**Placeholder scan:** No TBD/TODO; all code, commands, and skill body are literal. ✓

**Type consistency:** `GERMAN_CURSE`, `german-curse.txt`, `languages/experimental/german-curse.txt`, and the `pre_syllables`/`mid_syllables`/`sur_syllables` reader names (from `random_name_generator.rb`) are used consistently across Tasks 1 and 3. ✓
