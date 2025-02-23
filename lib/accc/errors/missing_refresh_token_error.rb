module ACCC
  module Errors
    class MissingRefreshTokenError < StandardError
      def initialize(msg = 'Refresh token is required to perform this operation')
        super
      end
    end
  end
end
