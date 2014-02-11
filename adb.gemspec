# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adb/version'

Gem::Specification.new do |spec|
  spec.name          = 'adb'
  spec.version       = Adb::VERSION
  spec.authors       = ['ART+COM AG']
  spec.email         = ['info@artcom.de']
  spec.description   = 'Ruby wrapper for the Android Debug Bridge (adb)'
  spec.summary       = 'Ruby wrapper for Android adb'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
