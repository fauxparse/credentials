module Credentials
  # Specifies an individual 'line' in a Rulebook.
  # Trivially subclassed as Credentials::Rule::AllowRule
  # and Credentials::Rule::DenyRule, but this is just
  # to allow you to create your own, more complex rule types.
  class Rule
    attr_accessor :parameters
    attr_accessor :options
    
    def initialize(*args)
      self.options = args.last.is_a?(Hash) ? args.pop : {}
      self.parameters = args
    end
    
    # Returns the number of arguments expected in a test to this
    # rule. This is really basic, but allows a quick first-pass
    # filtering of the rules.
    def arity
      parameters.length
    end
    
    # Returns +true+ if the given arguments match this rule.
    # Rules mostly use the same matching criteria as Ruby's
    # +case+ statement: that is, the <tt>===</tt> operator.
    # Remember:
    #     User === User.new   # a class matches an instance
    #     /\w+/ === "abc"     # a RegExp matches a valid string
    #     (1..5) === 3        # a Range matches a number
    #     :foo === :foo       # anything matches itself
    #
    # There are two exceptions to this behaviour. Firstly,
    # if the rule specifies an array, then the argument will
    # match any element of that array:
    #     class User
    #       credentials do |user|
    #         user.can [ :punch, :fight ], [ :shatner, :gandhi ]
    #       end
    #     end
    #     
    #     user.can? :fight, :gandhi  # => true
    #
    # Secondly, specifying <tt>:self</tt> in a rule is a nice
    # shorthand for specifying an object's permissions on itself:
    #     class User
    #       credentials do |user|
    #         user.can :fight, :self  # SPOILER ALERT
    #       end
    #     end
    def match?(*args)
      values = args.last.is_a?(Hash) ? args.pop : {}
      
      return false unless arity == args.length

      parameters.zip(args).each do |expected, actual|
        case expected
        when :self then return false unless actual == args.first
        when Array then return false unless expected.any? { |item| (item === actual) || (item == :self && actual == args.first) }
        else return false unless expected == actual || expected === actual
        end
      end
      
      result = true
      result = result && (options.keys & Credentials::Prepositions).inject(true) { |memo, key| memo && evaluate_preposition(args.first, options[key], values[key]) }
      result = result && evaluate_condition(options[:if], :|, *args) unless options[:if].nil?
      result = result && !evaluate_condition(options[:unless], :&, *args) unless options[:unless].nil?
      result
    end
    
    # Evaluates an +if+ or +unless+ condition.
    # [+conditions+]   One or more conditions to evaluate.
    #                  Can be symbols or procs.
    # [+op+]           Operator used to combine the results
    #                  (+|+ for +if+, +&+ for +unless+).
    # [+args+]         List of arguments to test with/against
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
          raise ArgumentError, "invalid :if or :unless option (expected Symbol or Proc, or array thereof; got #{condition.class})"
        end
      end
    end

    def evaluate_preposition(object, expected, actual)
      return true if expected.nil?
      return false if actual.nil?
      return true if expected === actual
      
      single = expected.to_s
      plural = single.respond_to?(:pluralize) ? single.pluralize : single + "s"
      
      lclass, rclass = [ object.class.name, actual.class.name ].map do |s|
        s.gsub(/^.*::/, '').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end

      if object.respond_to?(:id) && actual.respond_to?(:"#{lclass}_id")
        return true if actual.send(:"#{lclass}_id").to_i == object.id.to_i
      end
      
      if actual.respond_to?(:id) && object.respond_to?(:"#{rclass}_id")
        return true if object.send(:"#{rclass}_id").to_i == actual.id.to_i
      end
      
      (object.respond_to?(single) && (object.send(single) == actual)) || (object.respond_to?(plural) && (object.send(plural).include?(actual)))
    end
  end
end