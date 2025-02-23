MOCK_ACCESS_TOKEN = 'eyJhbGciOiJSUzI1NiIsImtpZCI6IlhrUFpfSmhoXzlTYzNZS01oRERBZFBWeFowOF9SUzI1NiIsInBpLmF0bSI6ImFzc2MifQ.eyJzY29wZSI6WyJkYXRhOnJlYWQiXSwiY2xpZW50X2lkIjoic3F6NmhtMVo0MTNoaERzSVhIUlJNcVF3elVHQWRCQVgiLCJpc3MiOiJodHRwczovL2RldmVsb3Blci5hcGkuYXV0b2Rlc2suY29tIiwiYXVkIjoiaHR0cHM6Ly9hdXRvZGVzay5jb20iLCJqdGkiOiJkTkVWZEdKOHA4WjVHOFc4a3pLOHhOY1E4dUR6a0ZwNFpaUTdTdG1Qa2UyS1lDRG9WT2o5eWkyaTVVbktKc2F3IiwiZXhwIjoxNzQwMzUyMzA1LCJ1c2VyaWQiOiJWTlYySERZR05LRVlROUxVIn0.lW4-eDs7HZnwo-9blsDZaRgMYPtKpBgvxRlrcVllakLgSZT37O4jlr8cQtxVNPiHUi8BfGPI7uuP9N3yQqIAs3ZgIEsPrWaksSCaJwDpQZok7OL4n_01FMFU5FZFpyCPLx-CecnU-wJEgjgzF9NS4E8wYDQQ03alhAD_fbBq2PwSupB09ULQDYvouJx4wRob2iCPVo4cN3PicvgUoHR2Sycg8x-9hs2cTgDuAzV4h-aUclkkURRhJg2IviTmzawzpQoDEUt610Hq_mdjsfok0LxoCg1rJv5PrXayWw1g9r2MlxnAY974f73u6tIjo8BPwTqR93C-yWKQw9_WvtKt3A'.freeze

require 'bundler/setup'
require 'dotenv'

# Set test environment variables
ENV['CLIENT_ID'] = 'test_client_id'
ENV['CLIENT_SECRET'] = 'test_client_secret'

require 'acc'
require 'webmock/rspec'
require 'vcr'

Dotenv.load

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :new_episodes }
  config.filter_sensitive_data('<CLIENT_ID>') { ENV.fetch('CLIENT_ID', nil) }
  config.filter_sensitive_data('<CLIENT_SECRET>') { ENV.fetch('CLIENT_SECRET', nil) }
  config.filter_sensitive_data('<ACCESS_TOKEN>') do
    MOCK_ACCESS_TOKEN
  end
  config.filter_sensitive_data('<REFRESH_TOKEN>') { '3ZwkGHmfEK5OwSthH4GhFvH3zlWtHEl25mmUe2tegu' }
  config.filter_sensitive_data('<PROJECT_ID>') { '71a20678-d059-42aa-9a82-7385e1cf4972' }
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
    ACC.configure do |c|
      # La configuración se tomará automáticamente de las variables de entorno
    end
  end
end
