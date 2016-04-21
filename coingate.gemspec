# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'coingate/version'

Gem::Specification.new do |spec|
  spec.name          = 'coingate'
  spec.version       = CoinGate::VERSION
  spec.authors       = ['Tomas Achmedovas', 'Irmantas Bačiulis']
  spec.email         = ['info@coingate.com']
  spec.summary       = %q{TODO}
  spec.description   = %q{TODO}
  spec.homepage      = 'https://coingate.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rest-client'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end