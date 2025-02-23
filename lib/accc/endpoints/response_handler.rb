module ACCC
  module Endpoints
    module ResponseHandler
      private

      def handle_json_response(response)
        case response.status
        when 200, 201
          JSON.parse(response.body)
        else
          raise Error, "Request failed: #{response.body}"
        end
      end
    end
  end
end 