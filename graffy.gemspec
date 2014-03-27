# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graffy/version'

Gem::Specification.new do |spec|
  spec.name          = "graffy"
  spec.version       = Graffy::VERSION
  spec.authors       = ["Tijmen Brommet"]
  spec.email         = ["tijmen@gmail.com"]
  spec.summary       = %q{Small graphs in Redis}
  spec.description   = %q{Library to work with small social graphs in Redis.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "redis"

  # spec.add_development_dependency "bundler", "~> 1.5.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
