module Credentials
  module Extensions #:nodoc:
    module Object
      module ClassMethods
        # The main method for specifying and retrieving the permissions of
        # a member of this class.
        #
        # When called with a block, this method yields a Credentials::Rulebook
        # object, allowing you to specify the class's credentials
        # in a declarative fashion. For example:
        #
        #     class User
        #       credentials do |user|
        #         user.can :edit, User, :if => :administrator?
        #         user.can :edit, :self
        #       end
        #     end
        #
        # You can also specify options in this way:
        #
        #     class User
        #       credentials(:default => :allow) do |user|
        #         user.cannot :eat, "ice cream", :if => :lactose_intolerant?
        #       end
        #     end
        #
        # The following options are supported:
        #
        # [+:default+] Whether to +:allow+ or +:deny+ permissions that aren't
        #              specified explicitly. The default default (!) is +:deny+.
        #
        # When called without a block, +credentials+ just returns the class's
        # Credentials::Rulebook, creating it if necessary.
        def credentials(options = nil)
          @credentials ||= Credentials::Rulebook.new(self)
          if block_given?
            @credentials.options.merge!(options) unless options.nil?
            
            # Only include the magic methods for classes where 'credentials' is
            # explicitly called with a block: otherwise, you get all kinds of 
            # RailsFails.
            unless included_modules.include?(Credentials::Extensions::MagicMethods)
              include Credentials::Extensions::MagicMethods 
            end
            yield @credentials
          else
            raise ArgumentError, "you can only set options with a block" unless options.nil?
          end
          @credentials
        end
      
        def inherited_with_credentials(child_class) #:nodoc:
          inherited_without_credentials(child_class) if child_class.respond_to? :inherited_without_credentials
          child_class.instance_variable_set("@credentials", Rulebook.for(child_class))
        end
      end
    
      # Returns true if the receiver has access to the specified resource or action.
      def can?(*args)
        self.class.credentials.allow? self, *args
      end
      alias_method :able_to?, :can?

      def self.included(receiver) #:nodoc:
        receiver.extend ClassMethods

        class << receiver
          alias_method :inherited_without_credentials, :inherited if respond_to? :inherited
          alias_method :inherited, :inherited_with_credentials
        end
      end
    end
  end
end