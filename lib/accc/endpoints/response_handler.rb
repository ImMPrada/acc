module ACCC
  module Endpoints
    module ResponseHandler
      private

      def handle_json_response(response)
        case response.status
        when 200, 201
          JSON.parse(response.body)
        when 401
          handle_unauthorized_error(response)
        else
          raise ACCC::Errors::Error, "Request failed: #{response.body}"
        end
      end

      def handle_unauthorized_error(response)
        error_body = JSON.parse(response.body)
        case error_body['error']
        when 'token_expired'
          raise ACCC::Errors::AccessTokenExpiredError
        when 'refresh_token_expired'
          raise ACCC::Errors::RefreshTokenExpiredError
        else
          raise ACCC::Errors::Error, "Authentication failed: #{error_body['error_description']}"
        end
      rescue JSON::ParserError
        raise ACCC::Errors::Error, "Invalid error response: #{response.body}"
      end
    end
  end
end
