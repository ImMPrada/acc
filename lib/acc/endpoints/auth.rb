module ACC
  module Endpoints
    class Auth
      include ResponseHandler

      TOKEN_ENDPOINT = '/authentication/v2/token'.freeze
      AUTHORIZE_ENDPOINT = '/authentication/v2/authorize'.freeze

      attr_reader :access_token, :refresh_token

      def initialize(access_token: nil, refresh_token: nil)
        @access_token = access_token
        @refresh_token = refresh_token
      end

      def authorization_url
        raise Errors::MissingScopeError, 'Scope must be configured' unless ACC.configuration.scope

        params = {
          client_id: ACC.configuration.client_id,
          response_type: 'code',
          redirect_uri: ACC.configuration.callback_url,
          scope: ACC.configuration.scope
        }

        "#{ACC.configuration.base_url}#{AUTHORIZE_ENDPOINT}?#{URI.encode_www_form(params)}"
      end

      def exchange_code(code)
        response = Faraday.post(
          "#{ACC.configuration.base_url}#{TOKEN_ENDPOINT}",
          {
            client_id: ACC.configuration.client_id,
            client_secret: ACC.configuration.client_secret,
            grant_type: 'authorization_code',
            code: code,
            redirect_uri: ACC.configuration.callback_url
          }
        )

        handle_token_response(response)
      end

      def refresh_tokens
        raise Errors::MissingRefreshTokenError unless @refresh_token

        response = Faraday.post(
          "#{ACC.configuration.base_url}#{TOKEN_ENDPOINT}",
          {
            client_id: ACC.configuration.client_id,
            client_secret: ACC.configuration.client_secret,
            grant_type: 'refresh_token',
            refresh_token: @refresh_token
          }
        )

        handle_token_response(response)
      end

      private

      def handle_token_response(response)
        tokens = handle_json_response(response)
        @refresh_token = tokens['refresh_token']
        @access_token = tokens['access_token']
      end
    end
  end
end
