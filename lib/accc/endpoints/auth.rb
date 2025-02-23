module ACCC
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
        raise ArgumentError, 'Scope must be configured' unless ACCC.configuration.scope

        params = {
          client_id: ACCC.configuration.client_id,
          response_type: 'code',
          redirect_uri: ACCC.configuration.callback_url,
          scope: ACCC.configuration.scope
        }

        "#{ACCC.configuration.base_url}#{AUTHORIZE_ENDPOINT}?#{URI.encode_www_form(params)}"
      end

      def exchange_code(code)
        response = Faraday.post(
          "#{ACCC.configuration.base_url}#{TOKEN_ENDPOINT}",
          {
            client_id: ACCC.configuration.client_id,
            client_secret: ACCC.configuration.client_secret,
            grant_type: 'authorization_code',
            code: code,
            redirect_uri: ACCC.configuration.callback_url
          }
        )

        tokens = handle_json_response(response)
        @access_token = tokens['access_token']
        @refresh_token = tokens['refresh_token']
        tokens
      end
    end
  end
end
