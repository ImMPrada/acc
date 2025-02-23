require 'spec_helper'

RSpec.describe ACCC do
  describe 'version' do
    it 'has a version number' do
      expect(described_class::VERSION).not_to be_nil
    end
  end

  describe '.configure' do
    let(:client_id) { 'test_client_id' }
    let(:client_secret) { 'test_client_secret' }

    it 'sets the client_id' do
      described_class.configure do |config|
        config.client_id = client_id
      end

      expect(described_class.configuration.client_id).to eq(client_id)
    end

    it 'sets the client_secret' do
      described_class.configure do |config|
        config.client_secret = client_secret
      end

      expect(described_class.configuration.client_secret).to eq(client_secret)
    end
  end
end
