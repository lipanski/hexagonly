# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hexagonal_tiling/version'

Gem::Specification.new do |spec|
  spec.name          = "hexagonal_tiling"
  spec.version       = HexagonalTiling::VERSION
  spec.authors       = ["Florin Lipan"]
  spec.email         = ["lipanski@gmail.com"]
  spec.description   = %q{Hexagonal tiling in Ruby.}
  spec.summary       = %q{Provides helper classes for performing regular hexagonal tiling.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

end
