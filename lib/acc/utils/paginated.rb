module ACC
  module Utils
    module Paginated
      DEFAULT_PAGE_SIZE = 10

      def all_paginated
        results = []

        make_paginated_request do |data|
          results += data['results']
        end

        results
      end

      protected

      def make_paginated_request
        page = 1
        loop do
          response = make_request(
            endpoint,
            params.merge(
              limit: DEFAULT_PAGE_SIZE,
              offset: page * DEFAULT_PAGE_SIZE
            )
          )

          handle_rate_limit(response)

          data = response.body
          break if data['results'].empty?

          yield(data)

          break unless data['pagination']['totalResults'] > ((page + 1) * DEFAULT_PAGE_SIZE)

          page += 1
        end

        self
      end

      def handle_rate_limit(response)
        # Verificar si hay un header de rate limit
        if response.headers['Retry-After']
          retry_after = response.headers['Retry-After'].to_i
          # Esperar el tiempo indicado antes de continuar
          sleep(retry_after) if retry_after.positive?
        end
        response
      end
    end
  end
end
