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
