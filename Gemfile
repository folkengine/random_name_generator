# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in random_name_generator.gemspec
gemspec

gem "pry"
gem "rake", "~> 13.4"

group :development do
  gem "logger" # logger leaves the default gems in Ruby 4.0; Reek (via dry-core) requires it implicitly.
  gem "reek"
  gem "rspec", "~> 3.12.0"
  gem "rubocop"
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
  gem "tsort" # tsort left the default gems in Ruby 4.1; RuboCop requires it implicitly.
end
