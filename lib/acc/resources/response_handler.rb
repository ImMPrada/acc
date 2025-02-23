module ACC
  module Resources
    module ResponseHandler
      private

      def handle_json_response(response)
        case response.status
        when 200, 201
          parse_and_validate_response(response)
        when 401
          handle_unauthorized_error(response)
        when 500
          handle_server_error(response)
        else
          handle_error_response(response)
        end
      end

      def parse_and_validate_response(response)
        parsed_body = parse_response_body(response)
        validate_token_response(parsed_body) if parsed_body.key?('access_token')
        parsed_body
      end

      def parse_response_body(response)
        JSON.parse(response.body)
      rescue JSON::ParserError
        raise ACC::Errors::AuthError, "Invalid error response: #{response.body}"
      end

      def validate_token_response(parsed_body)
        required_fields = %w[access_token token_type expires_in]
        missing_fields = required_fields - parsed_body.keys

        return unless missing_fields.any?

        raise ACC::Errors::AuthError, "Missing required fields in token response: #{missing_fields.join(', ')}"
      end

      def handle_unauthorized_error(response)
        parsed_body = parse_response_body(response)
        case parsed_body['error']
        when 'token_expired'
          raise ACC::Errors::AccessTokenError
        when 'refresh_token_expired'
          raise ACC::Errors::RefreshTokenError
        when 'invalid_grant'
          raise ACC::Errors::AuthError, 'Invalid authorization code'
        else
          raise ACC::Errors::AuthError, parsed_body['error_description'] || 'Unknown authentication error'
        end
      end

      def handle_server_error(response)
        parsed_body = parse_response_body(response)
        raise ACC::Errors::AuthError, "Request failed: #{parsed_body['error_description']}"
      end

      def handle_error_response(response)
        parsed_body = parse_response_body(response)
        error_message = parsed_body['error_description'] ||
                        parsed_body['developerMessage'] ||
                        'Unknown error occurred'

        raise ACC::Errors::AuthError, error_message
      end
    end
  end
end
