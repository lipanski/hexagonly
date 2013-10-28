# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hexagonly/version'

Gem::Specification.new do |spec|
  spec.name          = "hexagonly"
  spec.version       = Hexagonly::VERSION
  spec.authors       = ["Florin Lipan"]
  spec.email         = ["lipanski@gmail.com"]
  spec.description   = %q{Hexagonal tiling in Ruby.}
  spec.summary       = %q{Provides helper classes for performing regular, flat-topped hexagonal tiling and other polygon-related operations.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # General
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  # Testing
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "factory_girl"
  # Docs
  spec.add_development_dependency "yard"
  spec.add_development_dependency "redcarpet"

end
