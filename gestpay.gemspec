# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gestpay/version'

Gem::Specification.new do |spec|
  spec.name          = "gestpay"
  spec.version       = Gestpay::VERSION
  spec.authors       = ["Alessandro Mencarini"]
  spec.email         = ["a.mencarini@freegoweb.it"]
  spec.description   = %q{GestPay services wrapper}
  spec.summary       = %q{The gem will help with BancaSella payment webservices (initially the WSCryptDecrypt)}
  spec.homepage      = "http://momitians.github.io/gestpay"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "savon", "~> 2.2.0"
  spec.add_dependency "activesupport", "~> 3.2.13"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13.0"
  # spec.add_development_dependency "factory_girl", "~> 4.2.0"
  spec.add_development_dependency "vcr", "~> 2.4.0"
  spec.add_development_dependency "webmock", "~> 1.9.0"
end
