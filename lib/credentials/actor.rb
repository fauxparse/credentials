module Credentials
  module Actor
    def self.included(base)
      base.send :extend, ClassMethods
    end
    
    def can?(verb, *args)
      self.class.can?(self, verb, *args)
    end
    alias_method :able_to?, :can?

    module ClassMethods
      def can(verb, *args, &block)
        self.credentials << Credential.new(verb, *args, &block)
      end

      def can?(receiver, verb, *args)
        self.credentials.any? { |credential| credential.allow?(receiver, verb, *args) }
      end
    end
  end
end
