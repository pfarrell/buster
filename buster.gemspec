# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'buster/version'

Gem::Specification.new do |spec|
  spec.name          = "buster"
  spec.version       = Buster::VERSION
  spec.authors       = ["Pat Farrell"]
  spec.email         = ["pfarrell@ulive.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "twitter"
  spec.add_dependency "redis"
  spec.add_dependency "sinatra"
  spec.add_dependency "haml"
  spec.add_dependency "sinatra-contrib"
  spec.add_dependency "thin"
  spec.add_dependency 'capistrano', '~> 3.2.0'
  spec.add_dependency 'capistrano-bundler', '~> 1.1.2'
  spec.add_dependency 'time_trap'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "byebug"
end
