# RandomNameGenerator

[![Gem Version](https://badge.fury.io/rb/random_name_generator.svg)](https://badge.fury.io/rb/random_name_generator)
[![Build and Test](https://github.com/folkengine/random_name_generator/actions/workflows/ruby.yml/badge.svg)](https://github.com/folkengine/random_name_generator/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/folkengine/random_name_generator/badges/gpa.svg)](https://codeclimate.com/github/folkengine/random_name_generator)
[![Inline docs](http://inch-ci.org/github/folkengine/random_name_generator.svg?branch=master)](http://inch-ci.org/github/folkengine/random_name_generator)
[![AI BOM](https://img.shields.io/badge/AI--BOM-tracked-blueviolet)](./AI-BOM.md)

Ruby port of
[java-random-name-generator](https://github.com/folkengine/java-random-name-generator),
which in turn is a gradle enabled version of
[Sinipull's GPL'd post on codecall.net](http://forum.codecall.net/topic/49665-java-random-name-generator/).

**For other languages see
[RandomNameGeneratorHub](https://github.com/folkengine/RandomNameGeneratorHub)**.

The big difference between this random name generator and others is that
it allows you to create names in various custom styles such as Elven,
and Roman. If you're looking for a quick name for a Goblin NPC,
RandomNameGenerator is your gem.

------

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'random_name_generator'
```

And then execute:

    `$❯ bundle install`

Or install it yourself as:

    `$❯ gem install random_name_generator`

`RandomNameGenerator` also comes with a command line interface which will
generate a first and last name for you:

```shell
$> exe/random_name_generator [-egrkbfcxdß?]
```

You can also install it so that it's instantly available to you:

```shell
$> bundle exec rake install
$> random_name_generator --german-curse
Dummkopfischpopelsepp Schnoddmistmann
```

## Usage

RandomNameGenerator comes with several styles of syllable files:
[Elven](https://github.com/folkengine/random_name_generator/blob/master/lib/languages/elven.txt),
[Fantasy](https://github.com/folkengine/random_name_generator/blob/master/lib/languages/fantasy.txt),
[Goblin](https://github.com/folkengine/random_name_generator/blob/master/lib/languages/goblin.txt),
[Roman](https://github.com/folkengine/random_name_generator/blob/master/lib/languages/roman.txt),
[Klingon](https://github.com/folkengine/random_name_generator/blob/master/lib/languages/klingon.txt),
[Welsh](https://github.com/folkengine/random_name_generator/blob/master/lib/languages/welsh.txt),
and
[Belter](https://github.com/folkengine/random_name_generator/blob/master/lib/languages/belter.txt).
By default it uses Fantasy. Instantiate RandomNameGenerator and then
call compose on the object to generate a random name. If you don't pass
in the number of syllables you want for your name to compose, it will
randomly pick between 2 and 5.

```ruby
require 'random_name_generator'

rng = RandomNameGenerator.new
puts rng.compose(3)
```

*Technically, `RandomNameGenerator.new` is a static factory method
creating a RandomNameGenerator::Generator object.*

Pass in a reference to specific syllable file to get different styles of
random names:

```
rng = RandomNameGenerator.new(RandomNameGenerator::GOBLIN)
puts rng.compose(3)
```

Flip mode will create a RandomNameGenerator object, randomly assigning
the syllable file for you.

```ruby
flip = RandomNameGenerator.flip_mode
puts flip.compose
```

You can also pass in your own syllable files. See
[Syllable.rb](https://github.com/folkengine/random_name_generator/blob/master/lib/random_name_generator/syllable.rb)
for the required specification.

### Experimental languages

Edgier, less curated syllable sets live under `lib/languages/experimental/`
and are opt-in via their own constants:
[Curse](https://github.com/folkengine/random_name_generator/blob/master/lib/languages/experimental/curse.txt)
(`RandomNameGenerator::CURSE`),
[Demonic](https://github.com/folkengine/random_name_generator/blob/master/lib/languages/experimental/demonic.txt)
(`RandomNameGenerator::DEMONIC`), and
[German Curse](https://github.com/folkengine/random_name_generator/blob/master/lib/languages/experimental/german-curse.txt)
(`RandomNameGenerator::GERMAN_CURSE`).

## Porting and Refactoring Notes

The big refactoring over the original Java version is the creation of
the Syllable class. It takes over most of the complexity of parsing each
syllable, greatly simplifying the Random Name Generator code.

Part of the reason for working on this gem was to work on the following
goals to improve my Ruby craft:

* Code confidently in the spirit of Avdi Grimm's
  [Confident Ruby](http://www.confidentruby.com/).
* ~~Use
  [Travis-CI](https://travis-ci.org/folkengine/random_name_generator)
  for build validation.~~ Moved to GitHub Actions.
* Use [Rubocop](https://github.com/bbatsov/rubocop) and
  [Reek](https://github.com/troessner/reek) for code quality.
* Deploy it to
  [RubyGems.org](https://rubygems.org/gems/random_name_generator).


## Development

After checking out the repo, run `$❯ bin/setup` to install dependencies.
Then, run `$❯ rake spec` to run the tests. You can also run `$❯
bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will create
a git tag for the version, push git commits and the created tag, and
push the `.gem` file to [rubygems.org](https://rubygems.org).

To run [Reek](https://github.com/troessner/reek) on the codebase, simply
call `$❯ rake reek`

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/folkengine/random_name_generator.

## Skills

This ships with a skill designed to work with [Claude Code](https://claude.com/claude-code) 
and other LLMs under `.claude/skills/`.

- [lang-gen](.claude/skills/lang-gen/SKILL.md): Generate a new random_name_generator language from a free-text theme (e.g. "german curse words"), assembles flagged pre/mid/sur syllable collections, registers the File constant, adds a smoke spec and README entry, and samples names to verify.

There is also [a text version](docs/superpowers/specs/2026-07-19-lang-gen-portable-prompt.md) of the prompt that can be pasted into an LLM.

### lang-gen

Adding a language by hand means writing a `.txt` of prefix/middle/suffix
syllables, wiring up a `File` constant, adding a spec, and documenting it.
`lang-gen` does the whole flow from a plain-English theme.

Invoke it from Claude Code with the theme as the argument:

```
/lang-gen Klingon words of joy
```

This will:

1. Derive a **slug** (`klingon-joy`), **constant** (`KLINGON_JOY`), and
   destination; edgy themes land in `lib/languages/experimental/`, tame
   ones in `lib/languages/`; and confirm before writing.
2. Author the syllable file, seeding real roots for the theme and extending
   each of the three buckets (prefix `-`, middle, suffix `+`) with same-flavor
   syllables, adding `+v`/`+c`/`-v`/`-c` adjacency flags only where needed.
3. Register the `File` constant in `lib/random_name_generator.rb`.
4. Add a smoke spec to `spec/random_name_generator_spec.rb`.
5. Add a README entry linking the new language.
6. Verify that all three buckets are non-empty, then sample
   composed names so you can eyeball the result.

The experimental [German Curse](lib/languages/experimental/german-curse.txt)
language was generated this way.

## License

The gem is available as open source under the terms of the
[GNU Lesser General Public License version 3](https://opensource.org/licenses/LGPL-3.0).
