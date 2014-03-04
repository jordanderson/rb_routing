# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rb_routing/version'

Gem::Specification.new do |spec|
  spec.name          = "rb_routing"
  spec.version       = RbRouting::VERSION
  spec.authors       = ["Jordan Anderson"]
  spec.email         = ["jordandrsn@gmail.com"]
  spec.description   = "A pgRouting wrapper in ruby"
  spec.summary       = "A pgRouting wrapper in ruby"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"  
  spec.add_development_dependency "rake"
  spec.add_dependency "pg"
  spec.add_dependency "activerecord"

end
