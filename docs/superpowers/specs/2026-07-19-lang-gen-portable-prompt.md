# Lang-Gen Portable Prompt

Use this prompt with any LLM that can edit files and run commands in the repository.

## Goal

Generate a new `random_name_generator` language from a free-text theme such as `german curse words`. The result should be a fully integrated language file with a registered constant, a smoke spec, a README entry, and verification output.

## Language File DSL

Authoritative source: `lib/random_name_generator/syllable.rb`.

Each line of a language `.txt` file is one syllable:

- Leading `-` = prefix bucket, a name beginning.
- Leading `+` = suffix bucket, a name ending.
- No leading sign = middle bucket, an interior fragment.

Optional whitespace-separated flags after the syllable constrain adjacency:

- `+v` = the next syllable must start with a vowel.
- `+c` = the next syllable must start with a consonant.
- `-v` = this syllable may only follow one ending in a vowel.
- `-c` = this syllable may only follow one ending in a consonant.

A valid language needs all three buckets to be non-empty. `Generator#compose` picks a prefix, fills with middles, and ends with a suffix while honoring flags.

## Workflow

Follow these steps in order. Do not skip verification.

### 1. Parse the theme and derive names

From the theme string, derive and show the user for confirmation:

- Slug: concise kebab-case, 1-2 meaningful words, dropping filler such as `words`, `generator`, and articles. Example: `german curse words` -> `german-curse`.
- Constant: SCREAMING_SNAKE version of the slug. Example: `german-curse` -> `GERMAN_CURSE`.
- Destination: edgy themes such as curse, insult, swear, NSFW, or drunk go in `lib/languages/experimental/<slug>.txt`; tame themes go in `lib/languages/<slug>.txt`.

Before writing anything, check for collisions. If the target `.txt` file or the constant already exists, stop and ask the user how to proceed. Never overwrite.

### 2. Author the syllable file

1. Recall a handful of real roots for the theme. Example for German curses: `schei`, `arsch`, `sau`, `verdammt`, `dreck`, `mist`, `depp`, `blöd`.
2. Slot fragments into buckets: prefixes (`-`) are natural beginnings, middles are connective interiors, and suffixes (`+`) are natural endings or intensifiers.
3. Extend each bucket with same-flavor invented syllables until each bucket has roughly 20-40 entries, matching the scale of `lib/languages/goblin.txt`.
4. Add `+v`, `+c`, `-v`, and `-c` flags only where they prevent awkward clusters. Most lines should carry no flag.

Write the file to the destination chosen in step 1.

### 3. Register the constant

Edit `lib/random_name_generator.rb` and add the new `File` constant next to the matching group of constants. Put edgy themes under the existing `# Experimental` comment and tame themes with the curated constants.

Use the existing pattern:

```ruby
CONSTANT_NAME = File.new("#{dirname}/languages/<relative/path>.txt")
```

Do not change `flip_mode` or `flip_mode_cyrillic`; those arrays are curated.

### 4. Add a smoke spec

Add an example to `spec/random_name_generator_spec.rb` following the existing `with languages` conventions. The test should assert that the constant is a `File`, that its `path` includes the expected filename, and that a `Generator` built from it composes a non-empty `String`.

Example shape:

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

Add the new language to `README.md`. Edgy or experimental languages should go under a short experimental-languages note. Tame ones should join the curated list. Link to the file using the same style as the existing entries.

### 6. Verify

First parse-check the language file and confirm all three buckets are non-empty. Then sample about 10 composed names so the user can eyeball them. Finally, run the targeted spec.

Suggested commands:

```bash
bundle exec ruby -Ilib -rrandom_name_generator -e '
  g = RandomNameGenerator::Generator.new(RandomNameGenerator::CONSTANT_NAME)
  abort "empty pre"  if g.pre_syllables.empty?
  abort "empty mid"  if g.mid_syllables.empty?
  abort "empty sur"  if g.sur_syllables.empty?
  puts "buckets OK: #{g.pre_syllables.size}/#{g.mid_syllables.size}/#{g.sur_syllables.size}"
'
```

```bash
bundle exec ruby -Ilib -rrandom_name_generator -e '
  g = RandomNameGenerator::Generator.new(RandomNameGenerator::CONSTANT_NAME)
  10.times { puts g.compose }
'
```

```bash
bundle exec rspec spec/random_name_generator_spec.rb
```

If names look broken or monotonous, iterate on the `.txt` file and re-sample before finishing.

### 7. Hand off the commit

Do not run git commands yourself. Surface the exact command for the user:

```bash
git add lib/languages README.md lib/random_name_generator.rb spec/random_name_generator_spec.rb && git commit -m "Add <Theme> language via lang-gen"
```

## Guardrails

- Never overwrite an existing language file or constant without confirmation.
- Never run state-changing git commands; only suggest them.
- Keep bucket sizes and flag style consistent with existing `lib/languages/*.txt` files.
