module ACCC
  module Errors
    class MissingScopeError < StandardError
      def initialize(msg = 'Scope must be configured')
        super
      end
    end
  end
end
