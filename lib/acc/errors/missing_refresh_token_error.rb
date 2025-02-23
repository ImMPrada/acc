module ACC
  module Errors
    class MissingRefreshTokenError < AuthError
      def initialize(msg = 'Refresh token is required to perform this operation')
        super
      end
    end
  end
end
