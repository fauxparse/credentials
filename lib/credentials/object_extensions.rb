module Credentials
  module ObjectExtensions #:nodoc
    module ClassMethods
      def credentials(options = nil)
        @credentials ||= Credentials::Rulebook.new(self)
        if block_given?
          @credentials.options.merge!(options) unless options.nil?
          yield @credentials
        else
          raise ArgumentError, "you can only set options with a block" unless options.nil?
        end
        @credentials
      end
      
      def inherited_with_credentials(child_class) #:nodoc
        inherited_without_credentials(child_class) if child_class.respond_to? :inherited_without_credentials
        child_class.instance_variable_set("@credentials", Rulebook.for(child_class))
      end
    end
    
    module InstanceMethods
      def can?(*args)
        self.class.credentials.allow? self, *args
      end
      alias_method :able_to?, :can?
    end
    
    def self.included(receiver) #:nodoc
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      
      class << receiver
        alias_method :inherited_without_credentials, :inherited if respond_to? :inherited
        alias_method :inherited, :inherited_with_credentials
      end
    end
  end
end