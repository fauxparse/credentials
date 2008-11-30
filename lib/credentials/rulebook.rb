module Credentials
  class Rulebook
    attr_reader :rules
    
    def initialize(klass, rules = [])
      @rules = rules
      @klass = klass
    end
    
    def can(verb, *args)
      @rules << Rules::Can.new(@klass, verb, *args)
    end
    
    def cannot(verb, *args)
      @rules << Rules::Cannot.new(@klass, verb, *args)
    end
    
    #--
    # TODO allow ordering of rules to matter
    def can?(actor, verb, *args)
      @rules.any? { |rule| rule.allow?(actor, verb, *args) } &&
      !@rules.any? { |rule| rule.deny?(actor, verb, *args) }
    end
  end
end
