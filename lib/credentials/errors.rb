module Credentials
  module Errors
    class NotLoggedInError < StandardError
      
    end
    
    class AccessDeniedError < StandardError
      attr_reader :args
      
      def initialize(*args)
        @args = args
      end
    end
  end
end