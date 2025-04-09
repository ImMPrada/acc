module ACC
  module Clients
    module ConstructionCloud
      module Issues
        class Index < ConstructionCloud::Base
          include Utils::Paginated

          ENDPOINT = '/construction/issues/v1/projects/:projectId/issues'.freeze

          def initialize(auth, project_id)
            @project_id = project_id
            super(auth)
          end

          def make_request(endpoint, params = {})
            headers = request_headers
            response = connection.get do |req|
              req.url endpoint.sub(ACC.configuration.base_url, '')
              req.params = params
              req.headers = headers
            end

            raise ACC::Errors::RequestError, response.body unless response.success?

            response
          end

          private

          attr_reader :project_id

          def endpoint
            "#{ACC.configuration.base_url}#{ENDPOINT.gsub(':projectId', project_id)}"
          end

          def params
            {}
          end
        end
      end
    end
  end
end
