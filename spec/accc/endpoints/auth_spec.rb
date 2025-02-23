require 'spec_helper'

RSpec.describe ACCC::Endpoints::Auth do
  let(:client_id) { 'test_client_id' }
  let(:client_secret) { 'test_client_secret' }
  let(:callback_url) { 'https://example.com/callback' }
  let(:scope) { 'data:read data:write' }
  let(:base_url) { 'https://developer.api.autodesk.com' }
  let(:auth) { described_class.new }

  before do
    ACCC.configure do |config|
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
        ACCC.configure do |config|
          config.scope = nil
        end
      end

      it 'raises a MissingScopeError' do
        expect { auth.authorization_url }.to raise_error(
          ACCC::Errors::MissingScopeError,
          'Scope must be configured'
        )
      end
    end

    context 'when client_id is not configured' do
      before do
        ACCC.configure do |config|
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
        ACCC.configure do |config|
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

  describe '#exchange_code', :vcr do
    let(:authorization_code) { 'test_auth_code' }

    context 'when exchange is successful' do
      let!(:result) do
        VCR.use_cassette('auth/exchange_code/success') do
          auth.exchange_code(authorization_code)
        end
      end

      it 'returns an access token' do
        expect(result['access_token']).not_to be_nil
      end

      it 'returns a refresh token' do
        expect(result['refresh_token']).not_to be_nil
      end

      it 'returns an expiration time' do
        expect(result['expires_in']).not_to be_nil
      end

      it 'updates the instance access token' do
        expect(auth.access_token).to eq(result['access_token'])
      end

      it 'updates the instance refresh token' do
        expect(auth.refresh_token).to eq(result['refresh_token'])
      end
    end

    context 'when the token exchange fails' do
      let(:invalid_code) { 'invalid_code' }

      it 'raises an error with invalid grant message',
         vcr: { cassette_name: 'auth/exchange_code/invalid_grant' } do
        expect { auth.exchange_code(invalid_code) }
          .to raise_error(ACCC::Errors::Error, /Invalid authorization code/)
      end
    end

    context 'when access token has expired' do
      let(:expired_token) { 'expired_token' }

      it 'raises an AccessTokenExpiredError',
         vcr: { cassette_name: 'auth/exchange_code/token_expired' } do
        expect { auth.exchange_code(expired_token) }
          .to raise_error(ACCC::Errors::AccessTokenExpiredError)
      end
    end

    context 'when refresh token has expired' do
      let(:expired_refresh_token) { 'expired_refresh_token' }

      it 'raises a RefreshTokenExpiredError',
         vcr: { cassette_name: 'auth/exchange_code/refresh_token_expired' } do
        expect { auth.exchange_code(expired_refresh_token) }
          .to raise_error(ACCC::Errors::RefreshTokenExpiredError)
      end
    end
  end
end
