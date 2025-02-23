RSpec.describe ACCC do
  it "has a version number" do
    expect(ACCC::VERSION).not_to be nil
  end

  describe ".configure" do
    it "allows setting configuration" do
      api_key = "test_key"
      
      ACCC.configure do |config|
        config.api_key = api_key
      end

      expect(ACCC.configuration.api_key).to eq(api_key)
    end
  end
end 