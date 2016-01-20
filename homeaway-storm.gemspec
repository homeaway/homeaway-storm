# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'homeaway/storm/version'

Gem::Specification.new do |spec|
  spec.name          = 'homeaway-storm'
  spec.version       = HomeAway::Storm::VERSION
  spec.authors       = ['Charlie Meyer']
  spec.email         = ['cmeyer@homeaway.com']

  spec.summary       = %q{Ruby SDK for interacting with Apache Storm}
  spec.homepage      = 'https://www.homeaway.com/platform'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'hashie', '~> 3.4.3'
  spec.add_runtime_dependency 'rest-client', '~> 1.8.0'
  spec.add_runtime_dependency 'chronic', '~> 0.10.2'
  spec.add_runtime_dependency 'faraday', '~> 0.9.2'
  spec.add_runtime_dependency 'faraday_middleware', '~> 0.10.0'
  spec.add_runtime_dependency 'activesupport', '~> 4.2.5'
  spec.add_development_dependency 'json', '~> 1.8.2'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'vcr', '~> 3.0.1'
  spec.add_development_dependency 'multi_json', '~> 1.11.2'
  spec.add_development_dependency 'webmock', '~> 1.22.6'
  spec.add_development_dependency 'simplecov', '~> 0.11.0'
end
