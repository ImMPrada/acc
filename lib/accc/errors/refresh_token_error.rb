module ACCC
  module Errors
    class RefreshTokenError < AuthError
      def message
        'The refresh token has expired. User needs to re-authenticate.'
      end
    end
  end
end
