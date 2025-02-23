lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "accc/version"

Gem::Specification.new do |spec|
  spec.name          = "accc"
  spec.version       = ACCC::VERSION
  spec.authors       = ["Your Name"]
  spec.email         = ["your.email@example.com"]

  spec.summary       = %q{Ruby client for Autodesk Construction Cloud API}
  spec.description   = %q{A Ruby gem that provides a client interface for interacting with the Autodesk Construction Cloud API}
  spec.homepage      = "https://github.com/yourusername/accc"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.3.0"

  spec.files         = Dir.glob("{lib,spec}/**/*") + %w[README.md LICENSE.txt]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.18"
  spec.add_development_dependency "vcr", "~> 6.1"
  
  spec.add_dependency "faraday", "~> 2.7"
  spec.add_dependency "faraday-multipart", "~> 1.0"
  spec.add_dependency "zeitwerk", "~> 2.6"
end 