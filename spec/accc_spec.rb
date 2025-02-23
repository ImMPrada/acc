RSpec.describe ACCC do
  it 'has a version number' do
    expect(ACCC::VERSION).not_to be_nil
  end

  describe '.configure' do
    it 'allows setting configuration' do
      api_key = 'test_key'

      described_class.configure do |config|
        config.api_key = api_key
      end

      expect(described_class.configuration.api_key).to eq(api_key)
    end
  end
end
