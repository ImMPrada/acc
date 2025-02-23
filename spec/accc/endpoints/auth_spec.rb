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

      it 'returns a non-nil access token' do
        expect(result).not_to be_nil
      end

      it 'returns the same token stored in the instance' do
        expect(result).to eq(auth.access_token)
      end

      it 'updates the instance access token' do
        expect(auth.access_token).not_to be_nil
      end

      it 'updates the instance refresh token' do
        expect(auth.refresh_token).not_to be_nil
      end
    end

    context 'when the token exchange fails' do
      let(:invalid_code) { 'invalid_code' }

      it 'raises an error with invalid grant message',
         vcr: { cassette_name: 'auth/exchange_code/invalid_grant' } do
        expect { auth.exchange_code(invalid_code) }
          .to raise_error(ACCC::Errors::AuthError, /Invalid authorization code/)
      end
    end

    context 'when the response is not valid JSON' do
      let(:invalid_json_code) { 'invalid_json' }

      it 'raises an AuthError',
         vcr: { cassette_name: 'auth/exchange_code/invalid_json' } do
        expect { auth.exchange_code(invalid_json_code) }
          .to raise_error(ACCC::Errors::AuthError, /Invalid error response/)
      end
    end

    context 'when the server returns a 500 error' do
      let(:server_error_code) { 'server_error' }

      it 'raises an AuthError',
         vcr: { cassette_name: 'auth/exchange_code/server_error' } do
        expect { auth.exchange_code(server_error_code) }
          .to raise_error(ACCC::Errors::AuthError, /Request failed/)
      end
    end

    context 'when the response is missing required fields' do
      let(:incomplete_response_code) { 'incomplete' }
      let!(:result) do
        VCR.use_cassette('auth/exchange_code/incomplete_response') do
          auth.exchange_code(incomplete_response_code)
        end
      end

      it 'returns nil as access token' do
        expect(result).to be_nil
      end

      it 'does not set the instance access token' do
        expect(auth.access_token).to be_nil
      end

      it 'does not set the instance refresh token' do
        expect(auth.refresh_token).to be_nil
      end
    end

    context 'when access token has expired' do
      let(:expired_token) { 'expired_token' }

      it 'raises an AccessTokenError',
         vcr: { cassette_name: 'auth/exchange_code/token_expired' } do
        expect { auth.exchange_code(expired_token) }
          .to raise_error(ACCC::Errors::AccessTokenError)
      end
    end

    context 'when refresh token has expired' do
      let(:expired_refresh_token) { 'expired_refresh_token' }

      it 'raises a RefreshTokenError',
         vcr: { cassette_name: 'auth/exchange_code/refresh_token_expired' } do
        expect { auth.exchange_code(expired_refresh_token) }
          .to raise_error(ACCC::Errors::RefreshTokenError)
      end
    end
  end
end
