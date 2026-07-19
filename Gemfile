# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in random_name_generator.gemspec
gemspec

gem "pry"
gem "rake", "~> 13.4"
gem "slop", "~> 4.10.1"

group :development do
  gem "reek"
  gem "rspec", "~> 3.12.0"
  gem "rubocop"
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
  # tsort left the default gems in Ruby 4.1; RuboCop requires it implicitly.
  gem "tsort"
end
