module Credentials
  class Credential
    def initialize(verb, *args, &block)
      @options = (!args.empty? && args.last.is_a?(Hash)) ? args.pop : {}
      @verb = verb
      @conditions = args || []
      @block = block if block_given?
      [ @block, @options[:if], @options[:unless] ].compact.select { |fn| fn.is_a? Proc }.each do |fn|
        raise ArgumentError, "block should take #{args.size + 1} argument#{'s' unless args.empty?}" unless fn.arity == args.size + 1
      end
    end
    
    def match?(actor, verb, *args)
      if verb == @verb
        if args.size == @conditions.size
          @conditions.zip(args).each { |pattern, val| return false unless !pattern.is_a?(Class) or val == pattern or val.is_a?(pattern) }
          return true
        end
      end
      false
    end
    
    #--
    # TODO: allow overrides in subclasses
    def allow?(actor, verb, *args)
      return false unless match?(actor, verb, *args)
      result = true
      result &&= evaluate(@block, actor, *args) if @block
      result &&= evaluate(@options[:if], actor, *args) if @options[:if]
      result &&= !evaluate(@options[:unless], actor, *args) if @options[:unless]
      result
    end
  
  protected
    def evaluate(fn, actor, *args)
      case fn
      when Proc           then fn.call(actor, *args)
      when Symbol, String then actor.send(fn.to_sym, *args)
      else raise ArgumentError, "expected a proc or a symbol"
      end
    end
  end
end
