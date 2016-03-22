# RandomNameGenerator

[![Gem Version](https://badge.fury.io/rb/random_name_generator.svg)](https://badge.fury.io/rb/random_name_generator)
[![Build Status](https://travis-ci.org/folkengine/random_name_generator.svg?branch=master)](https://travis-ci.org/folkengine/random_name_generator)
[![Code Climate](https://codeclimate.com/github/folkengine/random_name_generator/badges/gpa.svg)](https://codeclimate.com/github/folkengine/random_name_generator)
[![Dependency Status](https://gemnasium.com/folkengine/random_name_generator.svg)](https://gemnasium.com/folkengine/random_name_generator)
[![Coverage Status](https://coveralls.io/repos/github/folkengine/random_name_generator/badge.svg?branch=master)](https://coveralls.io/github/folkengine/random_name_generator?branch=master)
[![Inline docs](http://inch-ci.org/github/folkengine/random_name_generator.svg?branch=master)][http://inch-ci.org/github/folkengine/random_name_generator]

Ruby port of [java-random-name-generator](https://github.com/folkengine/java-random-name-generator).

The big difference between this random name generator and others is that it allows you to create names in various
custom styles such as Elven, and Roman. If you're looking for a quick name for a Goblin NPC, RandomNameGenerator is
your gem.

------


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'random_name_generator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install random_name_generator

## Usage

RandomNameGenerator comes with several styles of syllable files:
[Elven](https://github.com/folkengine/random_name_generator/blob/master/lib/random_name_generator/languages/elven.txt),
[Fantasy](https://github.com/folkengine/random_name_generator/blob/master/lib/random_name_generator/languages/fantasy.txt),
[Goblin](https://github.com/folkengine/random_name_generator/blob/master/lib/random_name_generator/languages/goblin.txt),
and [Roman](https://github.com/folkengine/random_name_generator/blob/master/lib/random_name_generator/languages/roman.txt).
By default it uses Fantasy. Instantiate RandomNameGenerator and then call compose on the object to generate a random name.
If you don't pass in the number of syllables you want for your name  to compose, it will randomly pick between 3 and 6.

```ruby
require 'random_name_generator'

rng = RandomNameGenerator.new
puts rng.compose(3)
```

Pass in a reference to specific syllable file to get different styles of random names:

```ruby
rng = RandomNameGenerator.new(RandomNameGenerator::GOBLIN)
puts rng.compose(3)
```

Flip mode will create a RandomNameGenerator object, randomly assigning the syllable file for you.

```ruby
flip = RandomNameGenerator.flip_mode
puts flip.compose
```

You can also pass in your own syllable files. See
[RNGSyllable.rb](https://github.com/folkengine/random_name_generator/blob/master/lib/random_name_generator/rng_syllable.rb)
for the required specification.

RandomNameGenerator also comes with a command line interface which will generate a first and last name for you:

```ruby
bin/random_name_generator [-efgr?]
```

Add the gem's bin directory to you path in order to have instant access to RandomNameGenerator.

## Porting and Refactoring Notes

The big refactoring over the original Java version is the creation of the RNGSyllable class. It takes 
over most of the complexity of parsing each syllable, greatly simplifying the Random Name Generator code.
 
Part of the reason for working on this gem was to work on the following goals to improve my Ruby craft:

* Code confidently in the spirit of Advi Grimm's [Confident Ruby](http://www.confidentruby.com/).
* Use [Travis-CI](https://travis-ci.org/folkengine/random_name_generator) for build validation.
* Use [Rubocop](https://github.com/bbatsov/rubocop) and [Reek](https://github.com/troessner/reek) for code quality. 
* Deploy it to [RubyGems.org](https://rubygems.org/gems/random_name_generator).

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Dependencies

* [Mocha](https://github.com/freerange/mocha)
* [Reek](https://github.com/troessner/reek)
* [Rubocop](https://github.com/bbatsov/rubocop)

## Alternatives

There are several other great name generator gems. They really aren't designed for fantasy style names.

* [Faker](https://github.com/stympy/faker)
* [Namey](https://github.com/muffinista/namey)
* [How To Write A Name Generator (In Ruby)](http://www.skorks.com/2009/07/how-to-write-a-name-generator-in-ruby/)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/folkengine/random_name_generator.
