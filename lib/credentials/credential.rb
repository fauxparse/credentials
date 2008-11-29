module Credentials
  class Credential
    def initialize(verb, *args, &block)
      @options = (!args.empty? && args.last.is_a?(Hash)) ? args.pop : {}
      @verb = verb
      @conditions = args || []
      @block = block if block_given?
      [ @block, @options[:if], @options[:unless] ].compact.each do |fn|
        raise ArgumentError, "block should take #{args.size + 1} argument#{'s' unless args.empty?}" unless fn.arity == args.size + 1
      end
    end
    
    def match?(receiver, verb, *args)
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
    def allow?(receiver, verb, *args)
      return false unless match?(receiver, verb, *args)
      result = true
      result &&= evaluate(@block, receiver, *args) if @block
      result &&= evaluate(@options[:if], receiver, *args) if @options[:if]
      result &&= !evaluate(@options[:unless], receiver, *args) if @options[:unless]
      result
    end
  
  protected
    def evaluate(fn, receiver, *args)
      case fn
      when Proc           then fn.call(receiver, *args)
      when Symbol, String then receiver.send(fn.to_sym, *args)
      else raise ArgumentError, "expected a proc or a symbol"
      end
    end
  end
end
