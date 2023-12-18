# frozen_string_literal: true

require_relative "lib/random_name_generator/version"

Gem::Specification.new do |spec|
  spec.name          = "random_name_generator"
  spec.version       = RandomNameGenerator::VERSION
  spec.authors       = ["folkengine"]
  spec.email         = ["gaoler@electronicpanopticon.com"]

  spec.summary       = "Random Name Generator"
  spec.description   = "Generates random names based upon custom collections of syllables. Styles include Elvish, Fantasy, Goblin, and Roman."
  spec.homepage      = "https://github.com/folkengine/random_name_generator"
  spec.license       = "LGPL-3.0"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")
  spec.metadata = { "rubygems_mfa_required" => "true" }

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/folkengine/random_name_generator"
  spec.metadata["changelog_uri"] = "https://github.com/folkengine/random_name_generator/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
