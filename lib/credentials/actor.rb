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
      def can?(actor, verb, *args)
        self.credentials.any? { |credential| credential.allow?(actor, verb, *args) } ||
        by_association?(actor, verb, *args) ||
        by_actor_group?(actor, verb, *args)
      end
      
    protected
      def can(verb, *args, &block)
        self.credentials << Credential.new(verb, *args, &block)
      end

      def by_association?(actor, verb, *args)
        return false unless args.size == 1
        noun = verb.to_s.actorize
        object = args.first
        %w(of for on at in).each do |prep|
          return true if actor.respond_to?(method = "is_#{noun}_#{prep}?".to_sym) and actor.send(method, object)
        end
        object.respond_to?(method = noun.pluralize.to_sym) and object.send(method).include?(actor)
      end
      
      def by_actor_group?(actor, verb, *args)
        groups_for(actor).any? { |group| group.respond_to?(:can?) && group.can?(verb, *args) }
      end
      
      def groups_for(actor)
        case true
        when !credentials_options[:groups].blank? then Array(credentials_options[:groups]).map(&:to_sym).collect { |g| actor.send(g) }.flatten.uniq
        when actor.respond_to?(:groups) then actor.groups.flatten.uniq
        else []
        end
      end
    end
  end
end
