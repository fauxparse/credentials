require "credentials/rule"
require "credentials/allow_rule"
require "credentials/deny_rule"

module Credentials
  # Represents a collection of rules for granting and denying
  # permissions to instances of a class.
  # This is the return type of a call to a class's
  # +credentials+ method.
  class Rulebook
    attr_accessor :klass
    attr_accessor :options
    attr_accessor :rules
    
    DEFAULT_OPTIONS = {
      :default => :deny
    }.freeze
    
    def initialize(klass)
      self.klass = klass
      @rules = if klass.superclass.respond_to?(:credentials) && !klass.superclass.credentials.empty?
        klass.superclass.credentials.rules.dup
      else
        []
      end
      @options = {}
    end

    # Creates a Rulebook for the given class.
    # Should not be called directly: instead,
    # use +class.credentials+ (q.v.).
    def self.for(klass)
      rulebook = new(klass)
      if superclass && superclass.respond_to?(:credentials)
        rulebook.rules = superclass.credentials.rules.dup
      end
      rulebook
    end

    # Returns +true+ if there are no rules defined in this Rulebook.
    def empty?
      rules.empty?
    end
    
    # Declaratively specify a permission.
    # This is usually done in the context of a +credentials+ block
    # (see Credentials::ObjectExtensions::ClassMethods#credentials).
    # The examples below assume that context.
    #
    # == Simple (intransitive) permissions
    #     class User
    #       credentials do |user|
    #         user.can :log_in
    #       end
    #     end
    # Permission is expressed as a symbol; usually an intransitive verb.
    # Permission can be tested with:
    #     user.can? :log_in
    # or
    #     user.can_log_in?
    #
    # == Resource (transitive) permissions
    #     class User
    #       credentials do |user|
    #         user.can :edit, Post
    #       end
    #     end
    # As above, but a resource type is specified.
    # Permission can be tested with:
    #     user.can? :edit, Post.first
    # or
    #     user.can_edit? Post.first
    # 
    # == +if+ and +unless+
    # You can specify complex conditions with the +if+ and +unless+ options.
    # These options can be either a symbol (which is assumed to be a method
    # of the instance under test), or a proc, which is passed any non-symbol
    # arguments from the +can?+ method.
    #     class User
    #       credentials do |user|
    #         user.can :create, Post, :if => :administrator?
    #         user.can :edit, Post, :if => lambda { |user, post| user == post.author }
    #       end
    #     end
    #
    #     user.can? :create, Post  # checks user.administrator?
    #     user.can? :edit, post    # checks user == post.author
    #
    # Both +if+ and +unless+ options can be specified for the same rule:
    #     class User
    #       credentials do |user|
    #         user.can :eat, "chunky bacon", :if => :hungry?, :unless => :vegetarian?
    #       end
    #     end
    # So, only hungry users who are not vegetarian can eat chunky bacon.
    #
    # You can also specify multiple options for +if+ and +unless+.
    # If there are multiple options for +if+, any one match will do:
    #     class User
    #       credentials do |user|
    #         user.can :go_backstage, :if => [ :crew?, :good_looking? ]
    #       end
    #     end
    #
    # However, multiple options for +unless+ must _all_ match:
    #     class User
    #       credentials(:default => :allow) do |user|
    #         user.cannot :record, Album, :unless => [ :talented?, :dedicated? ]
    #       end
    #     end
    # You cannot record an album unless you are both talented and dedicated.
    # Note that we have specified the default permission as +allow+ in this example:
    # otherwise, the rule would never match.
    #
    # If your rules are any more complicated than that, you might want to
    # consider using the lambda form of arguments to +if+ and/or +unless+.
    #
    # == Reflexive permissions (+:self+)
    # The following two permissions are identical:
    #     class User
    #       credentials do |user|
    #         user.can :edit, User, :if => lambda { |user, another| user == another }
    #         user.can :edit, :self
    #       end
    #     end
    #
    # == Prepositions (+:for+, +:on+, etc)
    # You can do the following:
    #     class User
    #       credentials do |user|
    #         user.can :delete, Comment, :on => :post
    #       end
    #     end
    #
    #     user.can? :delete, post.comments.first, :on => post
    # ...means that Credentials will check if:
    # * +post+ has a +user_id+ method matching +user.id+
    # * +user+ has a +post_id+ method matching +post.id+
    # * +user+ has a +post+ method matching +post+
    # * +user+ has a +posts+ method that returns an array including +post+
    #
    # See Credentials::Prepositions for the list of available prepositions.
    def can(*args)
      self.rules << AllowRule.new(klass, *args)
    end
    
    # Declaratively remove a permission.
    # This is handy to explicitly remove a permission in a child class that
    # you have granted in a parent class.
    # It is also useful if your default is set to +allow+ and you want to
    # tighten up some permissions:
    #     class User
    #       credentials(:default => :allow) do |user|
    #         user.cannot :delete, :self
    #       end
    #     end
    # See Credentials::Rulebook#can for more on specifying permissions:
    # just remember that everything is backwards!
    def cannot(*args)
      self.rules << DenyRule.new(klass, *args)
    end
    
    # Determines whether to +:allow+ or +:deny+ by default.
    def default
      options[:default] && options[:default].to_sym
    end
    
    # Decides whether to allow the requested permission.
    #
    # == Match algorithm
    # 1. Set +ALLOWED+ to true if permission is specifically allowed
    #    by any allow_rules; otherwise, false.
    # 2. Set +DENIED+ to true if permission is specifically denied
    #    by any deny_rules; otherwise, false.
    # 3. The final result depends on the value of +default+:
    #    a. if +:allow+: <tt>ALLOWED OR !DENIED</tt>
    #    b. if +:deny+: <tt>ALLOWED AND !DENIED</tt>
    #
    # Expressed as a table:
    # <table>
    # <thead><tr><th>Matching rules</th><th>Default allow</th><th>Default deny</th></tr></thead>
    # <tbody>
    # <tr><td>None of the +allow+ or +deny+ rules matched.</td><td>allow</td><td>deny</td></tr>
    # <tr><td>Some of the +allow+ rules matched, none of the +deny+ rules matched.</td><td>allow</td><td>allow</td></tr>
    # <tr><td>None of the +allow+ rules matched, some of the +deny+ rules matched.</td><td>deny</td><td>deny</td></tr>
    # <tr><td>Some of the +allow+ rules matched, some of the +deny+ rules matched.</td><td>allow</td><td>deny</td></tr>
    # </tbody>
    # </table>
    def allow?(*args)
      allowed = allow_rules.inject(false) { |memo, rule| memo || rule.allow?(*args) }
      denied = deny_rules.inject(false) { |memo, rule| memo || rule.deny?(*args) }
      
      if default == :allow
        allowed or !denied
      else
        allowed and !denied
      end
    end
    
    # Subset of rules that grant permission by exposing an +allow?+ method.
    def allow_rules
      rules.select { |rule| rule.respond_to? :allow? }
    end
    
    # Subset of rules that deny permission by exposing an +deny?+ method.
    def deny_rules
      rules.select { |rule| rule.respond_to? :deny? }
    end
  end
end