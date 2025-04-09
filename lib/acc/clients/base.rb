module ACC
  module Clients
    class Base < HTTP::Client
      def make_request(endpoint, params = {})
        headers = request_headers
        # Si la URL ya incluye la base_url completa, simplemente usamos la ruta
        uri = URI(endpoint)
        url = uri.path
        url += "?#{uri.query}" if uri.query

        response = connection.get do |req|
          req.url url
          req.params = params
          req.headers = headers
        end

        raise ACC::Errors::RequestError, response.body unless response.success?

        response
      end
    end
  end
end
