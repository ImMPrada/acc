module ACCC
  module Errors
    class AccessTokenError < AuthError
      def message
        'The access token has expired. Please refresh the token.'
      end
    end
  end
end
