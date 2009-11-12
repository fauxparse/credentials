module Credentials
  module Extensions
    module ActionController
      module ClassMethods
        def requires_permission_to(*args)
          
        end
      end
      
      module InstanceMethods
        
      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end