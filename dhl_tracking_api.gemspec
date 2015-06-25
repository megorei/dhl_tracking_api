# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dhl_tracking_api/version'

Gem::Specification.new do |spec|
  spec.name          = "dhl_tracking_api"
  spec.version       = DhlTrackingApi::VERSION
  spec.authors       = ["Lars Gollnow"]
  spec.email         = ["lg@megorei.com"]
  spec.description   = %q{Simple API Client for DHL Track and Trace}
  spec.summary       = %q{accepts tracking code, returns current state of the delivery process}
  spec.homepage      = "https://github.com/megorei/dhl_tracking_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"

  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'patron'
end
