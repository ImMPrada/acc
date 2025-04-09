module ACC
  module Clients
    module ConstructionCloud
      module Issues
        class Me < ConstructionCloud::Base
          include Utils::Paginated

          ENDPOINT = '/construction/issues/v1/projects/:projectId/users/me'.freeze

          def initialize(auth, project_id)
            @project_id = project_id
            super(auth)
          end

          private

          attr_reader :project_id

          def call_request
            headers = request_headers
            @response = connection.get do |req|
              req.url endpoint.sub(ACC.configuration.base_url, '')
              req.params = params
              req.headers = headers
            end
          end

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
