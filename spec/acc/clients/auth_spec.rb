require 'spec_helper'

RSpec.describe ACC::Clients::Auth do
  let(:client_id) { 'test_client_id' }
  let(:client_secret) { 'test_client_secret' }
  let(:callback_url) { 'https://example.com/callback' }
  let(:scope) { 'data:read data:write' }
  let(:base_url) { 'https://developer.api.autodesk.com' }
  let(:auth) { described_class.new }

  before do
    ACC.configure do |config|
      config.client_id = client_id
      config.client_secret = client_secret
      config.callback_url = callback_url
      config.scope = scope
      config.base_url = base_url
    end
  end

  describe '#authorization_url' do
    context 'when all required configuration is present' do
      let(:expected_params) do
        {
          client_id: client_id,
          response_type: 'code',
          redirect_uri: callback_url,
          scope: scope
        }
      end
      let(:expected_query) { URI.encode_www_form(expected_params) }
      let(:expected_url) { "#{base_url}/authentication/v2/authorize?#{expected_query}" }

      it 'returns the correct authorization URL' do
        expect(auth.authorization_url).to eq(expected_url)
      end
    end

    context 'when scope is not configured' do
      before do
        ACC.configure do |config|
          config.scope = nil
        end
      end

      it 'raises a MissingScopeError' do
        expect { auth.authorization_url }.to raise_error(
          ACC::Errors::MissingScopeError,
          'Scope must be configured'
        )
      end
    end

    context 'when client_id is not configured' do
      before do
        ACC.configure do |config|
          config.client_id = nil
        end
      end

      let(:url) { auth.authorization_url }
      let(:parsed_params) { URI.decode_www_form(URI(url).query).to_h }

      it 'includes an empty client_id parameter' do
        expect(parsed_params['client_id']).to eq('')
      end
    end

    context 'when callback_url is not configured' do
      before do
        ACC.configure do |config|
          config.callback_url = nil
        end
      end

      let(:url) { auth.authorization_url }
      let(:parsed_params) { URI.decode_www_form(URI(url).query).to_h }

      it 'includes an empty redirect_uri parameter' do
        expect(parsed_params['redirect_uri']).to eq('')
      end
    end
  end

  # Los tests de exchange_code requieren VCR, los omitimos por ahora
  # describe '#exchange_code', :vcr do
  #   # ...
  # end
end
