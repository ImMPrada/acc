require 'bundler/setup'
require 'dotenv'

# Set test environment variables
ENV['CLIENT_ID'] = 'test_client_id'
ENV['CLIENT_SECRET'] = 'test_client_secret'

require 'accc'
require 'webmock/rspec'
require 'vcr'

Dotenv.load

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<CLIENT_ID>') { ENV['CLIENT_ID'] }
  config.filter_sensitive_data('<CLIENT_SECRET>') { ENV['CLIENT_SECRET'] }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    ACCC.configure do |c|
      # La configuración se tomará automáticamente de las variables de entorno
    end
  end
end
