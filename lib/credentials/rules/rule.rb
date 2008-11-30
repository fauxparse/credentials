module Credentials
  module Rules
    class Rule
      attr_accessor :verb
      attr_accessor :options
    
      def initialize(klass, verb, *args)
        @klass = klass
        @verb = verb.to_sym
        @options = args.last.is_a?(Hash) ? args.pop : {}
        @pattern = Array(args)
      end

      def match?(actor, verb, *args)
        return false unless actor == @klass or actor.is_a?(@klass)
        return false unless @verb == :any or @verb == verb.to_sym
        return false unless args.size == @pattern.size
        @pattern.zip(args).each { |pattern, arg| return false unless !pattern.is_a?(Class) or arg == pattern or arg.is_a?(pattern) }
      end
    
      def allow?(actor, verb, *args)
        return false unless match? actor, verb, *args
        result = true
        result &&= evaluate(@options[:if], actor, *args) if @options[:if]
        result &&= !evaluate(@options[:unless], actor, *args) if @options[:unless]
        result
      end
    
      def deny?(actor, verb, *args)
        return false unless match? actor, verb, *args
        result = false
        result ||= evaluate(@options[:unless], actor, *args) if @options[:unless]
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
end
