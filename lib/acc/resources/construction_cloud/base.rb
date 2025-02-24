module ACC
  module Resources
    module ConstructionCloud
      class Base
        RATE_LIMIT_HEADER = 'Retry-After'.freeze

        def initialize(auth)
          @auth = auth
        end

        protected

        def make_request
          # Implementation pending - will handle actual HTTP request
          raise NotImplementedError, "#{self.class} must implement #make_request"
        end

        def handle_rate_limit(response)
          return unless response.headers[RATE_LIMIT_HEADER]

          sleep(response.headers[RATE_LIMIT_HEADER].to_i)
        end

        private

        attr_reader :auth

        def connection
          @connection ||= Faraday.new(url: ACC.configuration.base_url) do |conn|
            conn.request :json
            conn.response :json
            conn.adapter Faraday.default_adapter
          end
        end

        def request_headers
          {
            'Authorization' => "Bearer #{access_token}",
            'Content-Type' => 'application/json'
          }
        end

        def access_token
          auth.access_token
        end
      end
    end
  end
end
