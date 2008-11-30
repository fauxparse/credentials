module Credentials
  module Actor
    def self.included(base) #:nodoc:
      base.send :extend, ClassMethods
    end
    
    # Returns true if the receiver has permission to perform the action ‘<tt>verb</tt>’ with the given <tt>args</tt>.
    def can?(verb, *args)
      self.class.can?(self, verb, *args)
    end
    alias_method :able_to?, :can?

    module ClassMethods
      # Returns true if the given <tt>actor</tt> has permission to perform the action ‘<tt>verb</tt>’ with the given <tt>args</tt>.
      def can?(actor, verb, *args)
        rulebook.can?(actor, verb, *args) ||
        can_by_association?(actor, verb, *args) ||
        can_by_actor_group?(actor, verb, *args)
      end
      
      # Returns true if any magic methods give the requested permission.
      # For example, <tt>by_association?(user, :edit, post)</tt> would try the following (in order):
      # * <tt>user.is_editor_of?(post)</tt>
      # * <tt>user.is_editor_for?(post)</tt>
      # * <tt>user.is_editor_on?(post)</tt>
      # * <tt>user.is_editor_at?(post)</tt>
      # * <tt>user.is_editor_in?(post)</tt>
      # * <tt>post.editor == user</tt>
      # * <tt>post.editors.include?(user)</tt>
      def can_by_association?(actor, verb, *args)
        return false unless args.size == 1
        noun = verb.to_s.actorize
        object = args.first
        %w(of for on at in).each do |prep|
          return true if actor.respond_to?(method = "is_#{noun}_#{prep}?".to_sym) and actor.send(method, object)
        end
        return true if object.respond_to?(method = noun.to_sym) and object.send(method) == actor
        return true if object.respond_to?(method = noun.pluralize.to_sym) and object.send(method).include?(actor)
        false
      end
      
      # Returns true if the actor belongs to any groups that have the requested permission.
      def can_by_actor_group?(actor, verb, *args)
        groups_for(actor).any? { |group| group.respond_to?(:can?) && group.can?(verb, *args) }
      end

      # Returns a list of the groups the user belongs to, according to the <tt>:groups</tt> option to <tt>has_credentials</tt>.
      def groups_for(actor)
        case true
        when !credential_options[:groups].blank? then Array(credential_options[:groups]).map(&:to_sym).collect { |g| actor.send(g) }.flatten.uniq
        when actor.respond_to?(:groups) then actor.groups.flatten.uniq
        else []
        end
      end
    end
  end
end
