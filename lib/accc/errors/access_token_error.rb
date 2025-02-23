module ACCC
  module Errors
    class AccessTokenExpiredError < StandardError
      def message
        'The access token has expired. Please refresh the token.'
      end
    end
  end
end
