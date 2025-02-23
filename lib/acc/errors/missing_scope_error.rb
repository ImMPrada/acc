module ACC
  module Errors
    class MissingScopeError < AuthError
      def initialize(msg = 'Scope must be configured')
        super
      end
    end
  end
end
