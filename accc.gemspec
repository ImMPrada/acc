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
  spec.homepage      = 'https://github.com/immprada/accc'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.3.6'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[
                          lib/**/*
                          bin/*
                          *.gemspec
                          LICENSE.txt
                          README.md
                        ]).reject { |f| File.directory?(f) }

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.7'
  spec.add_dependency 'faraday-multipart', '~> 1.0'
  spec.add_dependency 'zeitwerk', '~> 2.6'

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'changelog_uri' => "#{spec.homepage}/blob/main/CHANGELOG.md",
    'rubygems_mfa_required' => 'true',
    'bug_tracker_uri' => "#{spec.homepage}/issues"
  }
end
