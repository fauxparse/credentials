module Credentials
  module Rules
    class Cannot < Can
      def allow?(actor, verb, *args)
        return false unless match? actor, verb, *args
        result = false
        result ||= evaluate(@options[:unless], actor, *args) if @options[:unless]
        result
      end
    
      def deny?(actor, verb, *args)
        return false unless match? actor, verb, *args
        result = true
        result &&= evaluate(@options[:if], actor, *args) if @options[:if]
        result &&= !evaluate(@options[:unless], actor, *args) if @options[:unless]
        result
      end
    end
  end
end
