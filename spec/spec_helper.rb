require 'bundler/setup'
require 'dotenv'

# Set test environment variables
ENV['CLIENT_ID'] = 'test_client_id'
ENV['CLIENT_SECRET'] = 'test_client_secret'

require 'acc'
require 'support/vcr'

Dotenv.load

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    ACC.configure do |c|
      # La configuración se tomará automáticamente de las variables de entorno
    end
  end
end
