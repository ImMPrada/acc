module ACC
  module HTTP
    class Client
      include ResponseHandler

      attr_reader :connection

      def initialize(auth)
        @auth = auth
        @connection = create_connection
      end

      protected

      attr_reader :auth

      def create_connection
        Faraday.new(url: ACC.configuration.base_url) do |conn|
          conn.request :multipart
          conn.adapter Faraday.default_adapter
        end
      end

      def request_headers
        {
          'Authorization' => "Bearer #{auth.access_token}",
          'Content-Type' => 'application/json'
        }
      end
    end
  end
end
