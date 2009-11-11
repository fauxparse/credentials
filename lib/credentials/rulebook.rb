require "credentials/rule"
require "credentials/allow_rule"
require "credentials/deny_rule"

module Credentials
  class Rulebook
    attr_accessor :klass
    attr_accessor :options
    attr_accessor :rules
    
    DEFAULT_OPTIONS = {
      :default => :deny
    }.freeze
    
    def initialize(klass)
      self.klass = klass
      @rules = []
      @options = {}
    end

    def self.for(klass)
      rulebook = new(klass)
      if superclass && superclass.respond_to?(:credentials)
        rulebook.rules = superclass.credentials.rules.dup
      end
      rulebook
    end

    def empty?
      rules.empty?
    end
    
    def can(*args)
      self.rules << AllowRule.new(klass, *args)
    end
    
    def cannot(*args)
      self.rules << DenyRule.new(klass, *args)
    end
    
    def default
      options[:default] && options[:default].to_sym
    end
    
    def allow?(*args)
      allowed = allow_rules.inject(false) { |memo, rule| memo || rule.allow?(*args) }
      denied = deny_rules.inject(false) { |memo, rule| memo || rule.deny?(*args) }
      
      if default == :allow
        allowed or !denied
      else
        allowed and !denied
      end
    end
    
    def allow_rules
      rules.select { |rule| rule.respond_to? :allow? }
    end
    
    def deny_rules
      rules.select { |rule| rule.respond_to? :deny? }
    end
  end
end