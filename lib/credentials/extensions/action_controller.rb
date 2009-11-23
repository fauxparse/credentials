module Credentials
  module Extensions
    module ActionController
      module ClassMethods
        def requires_permission_to(*args)
          
        end
        
        def check_credentials
          
        end
      end
      
      def self.included(receiver)
        receiver.extend ClassMethods

        receiver.before_filter :check_credentials
      end
    end
  end
end