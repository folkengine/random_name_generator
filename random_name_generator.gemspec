# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'random_name_generator'
  spec.version       = '0.0.5'
  spec.authors       = ['folkengine']
  spec.email         = ['gaoler@electronicpanopticon.com']
  spec.licenses      = ['GPL-3.0']

  spec.summary       = 'Random Name Generator'
  spec.description   = 'Generates random names based upon custom collections of syllables. Styles include Elvish, Goblin, Roman'
  spec.homepage      = 'https://github.com/folkengine/random_name_generator'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.5'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
end
