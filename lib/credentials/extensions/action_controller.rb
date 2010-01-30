module Credentials
  module Extensions
    module ActionController
      module ClassMethods
        # Specify a requirement for the currently logged-in user
        # to be able to access particular actions.
        # 
        # The current user is determined by calling the method named in
        # +self.class.current_user_method+ (default is +current_user+).
        # If there is a rule set against the current action and no user
        # is logged in, then a Credentials::Errors::NotLoggedInError is
        # raised.
        #
        # Otherwise, the rules are treated like 'before' filters, with
        # the result being either a pass (action is executed as normal)
        # or a failure (Credentials::Errors::AccessDeniedError is raised).
        # (Note that evaluation stops at the first failure.)
        # 
        # Just like ActionController's built-in filters, you can use
        # +only+ and +unless+ to restrict the scope of your rules.
        # 
        # == Credential tests
        #
        # For the most part, these are carried out as you'd expect:
        #     requires_permission_to :create, Post
        #     # checks current_user.can? :create, Post
        #
        # However, the magic part is that any symbol arguments are
        # evaluated against the current controller instance, if
        # matching methods can be found, allowing you to do this:
        #    class PostsController
        #      requires_permission_to :edit, :current_post, 
        #        :only => %w(edit update destroy)
        #    
        #      def edit
        #        # ...
        #      end
        #    
        #    protected
        #      def current_post
        #        @current_post ||= Post.find params[:id]
        #      end
        #    end
        #
        # Note that for this to work, the +current_post+ method
        # must be declared +protected+. The reason for this is that
        # otherwise Credentials would also try to evaluate the
        # +edit+ method as an argument.
        def requires_permission_to(*args)
          options = (args.last.is_a?(Hash) ? args.pop : {})
          [ :only, :except ].each do |key|
            options[key] = Array(options[key]).map(&:to_sym) if options[key]
          end
          self.required_credentials = self.required_credentials + [ [ options, args ] ]
        end
        
        def required_credentials #:nodoc:
          read_inheritable_attribute(:required_credentials) || []
        end

        # Sets the method for determining the current user in a
        # controller instance.
        # (Default: +:current_user+)
        def current_user_method(value = nil)
          rw_config(:current_user_method, value, :current_user)
        end
        alias_method :current_user_method=, :current_user_method
      end
      
    protected
      # Acts as a +before_filter+ to check credentials before an action
      # is executed.
      #
      # See Credentials::Extensions::ActionController::ClassMethods#requires_permission_to
      # for more details.
      def check_credentials
        current_user = send self.class.current_user_method
        current_action = action_name.to_sym
        
        self.class.required_credentials.each do |options, args|
          next if options[:only] && !options[:only].include?(current_action)
          next if options[:except] && options[:except].include?(current_action)
          
          raise Credentials::Errors::NotLoggedInError unless current_user
          evaluated = args.map do |arg|
            if arg.is_a?(Symbol) && respond_to?(arg) && !action_named?(arg)
              send(arg)
            else
              arg
            end
          end
          
          opts = returning({}) do |hash|
            (Credentials::Prepositions & options.keys).each do |prep|
              hash[prep] = send(options[prep])
            end
          end
          evaluated << opts
          
          unless current_user.can?(*evaluated)
            raise Credentials::Errors::AccessDeniedError
          end
        end
      end
      
      def action_named?(method)
        method_name = (RUBY_VERSION.to_f >= 1.9) ? method.to_sym : method.to_s
        public_methods.include?(method_name)
      end
      
      def self.included(receiver) #:nodoc:
        receiver.extend Credentials::Extensions::Configuration
        receiver.extend ClassMethods

        receiver.send :class_inheritable_writer, :required_credentials
        receiver.before_filter :check_credentials
      end
    end
  end
end