# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'squaremill/version'

Gem::Specification.new do |spec|
  spec.name          = "squaremill"
  spec.version       = Squaremill::VERSION
  spec.authors       = ["Conor Hunt"]
  spec.email         = ["conor.hunt+git@gmail.com"]
  spec.description   = %q{A tool to create a static website}
  spec.summary       = %q{A tool to create a static website from templates}
  spec.homepage      = "https://github.com/SquareMill/squaremill"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  #spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry-byebug"
end
