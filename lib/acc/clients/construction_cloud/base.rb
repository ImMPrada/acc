module ACC
  module Clients
    module ConstructionCloud
      class Base < ACC::Clients::Base
        RATE_LIMIT_HEADER = 'Retry-After'.freeze

        attr_reader :response

        def initialize(auth)
          @auth = auth
          super
        end

        def rate_freeze
          response.headers[RATE_LIMIT_HEADER]&.to_i
        end

        protected

        def make_request
          # call request
          call_request
          # raise errors
          raise ACC::Errors::BadRequestError, 'The request was invalid.' if response.status == 400
          raise ACC::Errors::ForbiddenRequestError, 'The request was forbidden.' if response.status == 403
          raise ACC::Errors::NotFoundError, 'The request was not found.' if response.status == 404
        end

        private

        attr_reader :auth

        def call_request
          raise NotImplementedError, "#{self.class} must implement #request"
        end

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

        def response_pagination(response)
          response.body['pagination'].to_h
        end
      end
    end
  end
end
