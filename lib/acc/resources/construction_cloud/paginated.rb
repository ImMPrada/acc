module ACC
  module Resources
    module ConstructionCloud
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
      end
    end
  end
end
