module Credentials
  module Extensions
    module ActionController
      module ClassMethods
        def requires_permission_to(*args)
          options = (args.last.is_a?(Hash) ? args.pop : {}).with_indifferent_access
          %w(only except).each do |key|
            options[key] = Array(options[key]).map(&:to_sym) if options[key]
          end
          self.required_credentials = self.required_credentials + [ [ options, args ] ]
        end
        
        def required_credentials
          read_inheritable_attribute(:required_credentials) || []
        end
      end
      
      module Configuration
        def current_user_method(value = nil)
          rw_config(:current_user_method, value, :current_user)
        end
        alias_method :current_user_method=, :current_user_method
      end
      
    protected
      def check_credentials
        current_user = send self.class.current_user_method
        raise Credentials::Errors::NotLoggedInError unless current_user

        current_action = action_name.to_sym
        self.class.required_credentials.each do |options, args|
          next if options[:only] && !options[:only].include?(current_action)
          next if options[:except] && options[:except].include?(current_action)
          evaluated = args.map { |arg| (arg.is_a?(Symbol) && respond_to?(arg)) ? send(arg) : arg }
          
          unless current_user.can?(*evaluated)
            raise Credentials::Errors::AccessDeniedError
          end
        end
      end
      
      def self.included(receiver)
        receiver.extend ClassMethods
        receiver.extend Credentials::Extensions::Configuration
        receiver.extend Configuration

        receiver.send :class_inheritable_writer, :required_credentials
        receiver.before_filter :check_credentials
      end
    end
  end
end