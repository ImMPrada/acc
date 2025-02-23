require 'spec_helper'

RSpec.describe ACCC::Endpoints::Auth do
  let(:client_id) { 'test_client_id' }
  let(:client_secret) { 'test_client_secret' }
  let(:callback_url) { 'https://example.com/callback' }
  let(:scope) { 'data:read data:write' }
  let(:base_url) { 'https://developer.api.autodesk.com' }

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
    subject(:auth) { described_class.new }

    context 'when all required configuration is present' do
      it 'returns the correct authorization URL with parameters' do
        expected_params = {
          client_id: client_id,
          response_type: 'code',
          redirect_uri: callback_url,
          scope: scope
        }
        expected_query = URI.encode_www_form(expected_params)
        expected_url = "#{base_url}/authentication/v2/authorize?#{expected_query}"

        expect(auth.authorization_url).to eq(expected_url)
      end
    end

    context 'when scope is not configured' do
      before do
        ACCC.configure do |config|
          config.scope = nil
        end
      end

      it 'raises an ArgumentError' do
        expect { auth.authorization_url }.to raise_error(
          ArgumentError,
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

      it 'includes an empty client_id in the URL' do
        url = auth.authorization_url
        parsed_params = URI.decode_www_form(URI(url).query).to_h
        expect(parsed_params['client_id']).to eq('')
      end
    end

    context 'when callback_url is not configured' do
      before do
        ACCC.configure do |config|
          config.callback_url = nil
        end
      end

      it 'includes an empty redirect_uri in the URL' do
        url = auth.authorization_url
        parsed_params = URI.decode_www_form(URI(url).query).to_h
        expect(parsed_params['redirect_uri']).to eq('')
      end
    end
  end

  describe '#exchange_code' do
    subject(:auth) { described_class.new }

    let(:authorization_code) { 'test_auth_code' }
    let(:access_token) { 'test_access_token' }
    let(:refresh_token) { 'test_refresh_token' }
    let(:token_endpoint) { "#{base_url}/authentication/v2/token" }
    let(:successful_response) do
      {
        access_token: access_token,
        refresh_token: refresh_token,
        expires_in: 3600
      }
    end

    context 'when exchange is successful' do
      before do
        stub_request(:post, token_endpoint)
          .with(
            body: {
              client_id: client_id,
              client_secret: client_secret,
              grant_type: 'authorization_code',
              code: authorization_code,
              redirect_uri: callback_url
            }
          )
          .to_return(
            status: 200,
            body: successful_response.to_json,
            headers: { 'Content-Type': 'application/json' }
          )
      end

      it 'returns the access token' do
        result = auth.exchange_code(authorization_code)
        expect(result['access_token']).to eq(access_token)
      end

      it 'returns the refresh token' do
        result = auth.exchange_code(authorization_code)
        expect(result['refresh_token']).to eq(refresh_token)
      end

      it 'returns the expiration time' do
        result = auth.exchange_code(authorization_code)
        expect(result['expires_in']).to eq(3600)
      end

      it 'updates the instance access token' do
        auth.exchange_code(authorization_code)
        expect(auth.access_token).to eq(access_token)
      end

      it 'updates the instance refresh token' do
        auth.exchange_code(authorization_code)
        expect(auth.refresh_token).to eq(refresh_token)
      end
    end

    context 'when the token exchange fails' do
      before do
        stub_request(:post, token_endpoint)
          .to_return(
            status: 400,
            body: {
              error: 'invalid_grant',
              error_description: 'Invalid authorization code'
            }.to_json,
            headers: { 'Content-Type': 'application/json' }
          )
      end

      it 'raises an error' do
        expect { auth.exchange_code(authorization_code) }.to raise_error(ACCC::Errors::Error)
      end
    end

    context 'when access token has expired' do
      before do
        stub_request(:post, token_endpoint)
          .to_return(
            status: 401,
            body: {
              error: 'token_expired',
              error_description: 'Access token has expired'
            }.to_json,
            headers: { 'Content-Type': 'application/json' }
          )
      end

      it 'raises an AccessTokenExpiredError' do
        expect { auth.exchange_code(authorization_code) }
          .to raise_error(ACCC::Errors::AccessTokenExpiredError)
      end
    end

    context 'when refresh token has expired' do
      before do
        stub_request(:post, token_endpoint)
          .to_return(
            status: 401,
            body: {
              error: 'refresh_token_expired',
              error_description: 'Refresh token has expired'
            }.to_json,
            headers: { 'Content-Type': 'application/json' }
          )
      end

      it 'raises a RefreshTokenExpiredError' do
        expect { auth.exchange_code(authorization_code) }
          .to raise_error(ACCC::Errors::RefreshTokenExpiredError)
      end
    end
  end
end
