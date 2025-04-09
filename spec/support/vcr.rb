MOCK_ACCESS_TOKEN = 'eyJhbGciOiJSUzI1NiIsImtpZCI6IlhrUFpfSmhoXzlTYzNZS01oRERBZFBWeFowOF9SUzI1NiIsInBpLmF0bSI6ImFzc2MifQ.eyJzY29wZSI6WyJkYXRhOnJlYWQiXSwiY2xpZW50X2lkIjoic3F6NmhtMVo0MTNoaERzSVhIUlJNcVF3elVHQWRCQVgiLCJpc3MiOiJodHRwczovL2RldmVsb3Blci5hcGkuYXV0b2Rlc2suY29tIiwiYXVkIjoiaHR0cHM6Ly9hdXRvZGVzay5jb20iLCJqdGkiOiJkTkVWZEdKOHA4WjVHOFc4a3pLOHhOY1E4dUR6a0ZwNFpaUTdTdG1Qa2UyS1lDRG9WT2o5eWkyaTVVbktKc2F3IiwiZXhwIjoxNzQwMzUyMzA1LCJ1c2VyaWQiOiJWTlYySERZR05LRVlROUxVIn0.lW4-eDs7HZnwo-9blsDZaRgMYPtKpBgvxRlrcVllakLgSZT37O4jlr8cQtxVNPiHUi8BfGPI7uuP9N3yQqIAs3ZgIEsPrWaksSCaJwDpQZok7OL4n_01FMFU5FZFpyCPLx-CecnU-wJEgjgzF9NS4E8wYDQQ03alhAD_fbBq2PwSupB09ULQDYvouJx4wRob2iCPVo4cN3PicvgUoHR2Sycg8x-9hs2cTgDuAzV4h-aUclkkURRhJg2IviTmzawzpQoDEUt610Hq_mdjsfok0LxoCg1rJv5PrXayWw1g9r2MlxnAY974f73u6tIjo8BPwTqR93C-yWKQw9_WvtKt3A'.freeze
MOCK_REFRESH_TOKEN = 'MihNEgB9kmPNv5qOqEMEosQADgDJRolZaDSRrjoF4c'.freeze
MOCK_PROJECT_ID = 'cfd4dbc0-d2ff-4295-957d-6da26067aefd'.freeze
MOCK_USER_ID = 'VNV2HDYGKEYQ9LU'.freeze

require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :new_episodes }
  
  # Filtros para datos sensibles
  config.filter_sensitive_data('<CLIENT_ID>') { ENV.fetch('CLIENT_ID', nil) }
  config.filter_sensitive_data('<CLIENT_SECRET>') { ENV.fetch('CLIENT_SECRET', nil) }
  config.filter_sensitive_data('<ACCESS_TOKEN>') { MOCK_ACCESS_TOKEN }
  config.filter_sensitive_data('<REFRESH_TOKEN>') { MOCK_REFRESH_TOKEN }
  config.filter_sensitive_data('<PROJECT_ID>') { MOCK_PROJECT_ID }
  config.filter_sensitive_data('<USER_ID>') { MOCK_USER_ID }
  
  # Filtros para URLs
  config.filter_sensitive_data('https://developer.api.autodesk.com') { 'https://api.example.com' }
  
  # Filtros para headers
  config.filter_sensitive_data('Bearer <ACCESS_TOKEN>') { "Bearer #{MOCK_ACCESS_TOKEN}" }
  
  # Filtros para respuestas JSON
  config.before_record do |interaction|
    if interaction.response.headers['Content-Type']&.include?('application/json')
      body = interaction.response.body
      if body.is_a?(String)
        begin
          json = JSON.parse(body)
          # Anonimizar datos sensibles en la respuesta
          json['userId'] = MOCK_USER_ID if json['userId']
          json['projectId'] = MOCK_PROJECT_ID if json['projectId']
          interaction.response.body = JSON.generate(json)
        rescue JSON::ParserError
          # Si no es JSON válido, dejarlo como está
        end
      end
    end
  end
end
