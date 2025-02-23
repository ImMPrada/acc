module ACCC
  module Errors
    class RefreshTokenExpiredError < StandardError
      def message
        'The refresh token has expired. User needs to re-authenticate.'
      end
    end
  end
end
