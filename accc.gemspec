lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'accc/version'

Gem::Specification.new do |spec|
  spec.name          = 'accc'
  spec.version       = ACCC::VERSION
  spec.authors       = ['immprada']
  spec.email         = ['im.mprada@gmail.com']

  spec.summary       = 'Ruby client for Autodesk Construction Cloud API'
  spec.description   = 'Ruby client library for interacting with the Autodesk Construction Cloud API'
  spec.homepage      = 'https://github.com/yourusername/accc'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.3.6'

  spec.files         = Dir.glob('{lib,spec}/**/*') + %w[README.md LICENSE.txt]
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.7'
  spec.add_dependency 'faraday-multipart', '~> 1.0'
  spec.add_dependency 'zeitwerk', '~> 2.6'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
