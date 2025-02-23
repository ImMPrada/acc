source 'https://rubygems.org'

ruby '3.3.6'

# Specify your gem's dependencies in accc.gemspec
gemspec

group :development do
  gem 'bundler', '~> 2.0'
  gem 'rake', '~> 13.0'
  gem 'rubocop', '~> 1.72'
  gem 'rubocop-rake'
  gem 'rubocop-rspec', '~> 3.5'
end

group :test do
  gem 'rspec', '~> 3.0'
  gem 'vcr', '~> 6.1'
  gem 'webmock', '~> 3.18'
end

group :development, :test do
  gem 'dotenv'
end

gem 'mdl', '~> 0.13.0'
