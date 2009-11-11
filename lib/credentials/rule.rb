module Credentials
  class Rule
    attr_accessor :parameters
    attr_accessor :options
    
    def initialize(*args)
      self.options = args.last.is_a?(Hash) ? args.pop : {}
      self.parameters = args
    end
    
    def arity
      parameters.length
    end
    
    def match?(*args)
      return false unless arity == args.length
      
      parameters.zip(args).each do |expected, actual|
        return false unless expected === actual
      end
      result = true
      result = result && evaluate_condition(options[:if], :|, *args) unless options[:if].nil?
      result = result && !evaluate_condition(options[:unless], :&, *args) unless options[:unless].nil?
      result
    end
    
    def evaluate_condition(conditions, op, *args)
      receiver = args.shift
      args.reject! { |arg| arg.is_a? Symbol }
      Array(conditions).inject(op == :| ? false : true) do |memo, condition|
        memo = memo.send op, case condition
        when Symbol
          return false unless receiver.respond_to? condition
          !!receiver.send(condition, *args[0, receiver.method(condition).arity])
        when Proc
          raise ArgumentError, "wrong number of arguments to condition (#{args.size} to #{condition.arity})" unless args.size + 1 == condition.arity
          !!condition.call(receiver, *args)
        else
          !!condition
        end
      end
    end
  end
end