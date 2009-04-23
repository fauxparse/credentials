module Credentials
  class Rulebook
    attr_reader :rules
    
    def initialize(klass, rules = [])
      @rules = rules
      @klass = klass
    end
    
    def can(verb, *args)
      @rules << Credentials::Rules::Can.new(@klass, verb, *args)
    end
    
    def cannot(verb, *args)
      @rules << Credentials::Rules::Cannot.new(@klass, verb, *args)
    end
    
    def can?(actor, verb, *args)
      result = @klass.credential_options[:allow_by_default] || false
      @rules.each do |rule|
        result = true if rule.allow?(actor, verb, *args)
        result = false if rule.deny?(actor, verb, *args)
      end
      result
    end
  end
end
