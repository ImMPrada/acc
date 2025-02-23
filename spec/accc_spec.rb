require 'spec_helper'

RSpec.describe ACCC do
  describe 'version' do
    it 'has a version number' do
      expect(ACCC::VERSION).not_to be nil
    end
  end

  describe '.configure' do
    it 'allows setting configuration' do
      client_id = 'test_client_id'
      client_secret = 'test_client_secret'

      ACCC.configure do |config|
        config.client_id = client_id
        config.client_secret = client_secret
      end

      expect(ACCC.configuration.client_id).to eq(client_id)
      expect(ACCC.configuration.client_secret).to eq(client_secret)
    end
  end
end
