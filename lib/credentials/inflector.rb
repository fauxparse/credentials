require "singleton"

module Credentials
  module Inflector
    extend self
    
    class Inflections
      include Singleton
      
      attr_reader :actors

      def actors
        @actors ||= []
      end

      def actor(rule, replacement)
        actors.insert 0, [ rule, replacement ]
      end
      
      unless defined?(ActiveSupport)
        attr_reader :plurals, :singulars, :uncountables
        
        def initialize
          @plurals, @singulars, @uncountables = [], [], []
        end
        
        def plurals
          @plurals ||= []
        end
        
        def plural(rule, replacement)
          plurals.insert 0, [ rule, replacement ]
        end
        def plural(rule, replacement)
          @uncountables.delete(rule) if rule.is_a?(String)
          @uncountables.delete(replacement)
          @plurals.insert(0, [rule, replacement])
        end

        def singular(rule, replacement)
          @uncountables.delete(rule) if rule.is_a?(String)
          @uncountables.delete(replacement)
          @singulars.insert(0, [rule, replacement])
        end

        def irregular(singular, plural)
          @uncountables.delete(singular)
          @uncountables.delete(plural)
          if singular[0,1].upcase == plural[0,1].upcase
            plural(Regexp.new("(#{singular[0,1]})#{singular[1..-1]}$", "i"), '\1' + plural[1..-1])
            singular(Regexp.new("(#{plural[0,1]})#{plural[1..-1]}$", "i"), '\1' + singular[1..-1])
          else
            plural(Regexp.new("#{singular[0,1].upcase}(?i)#{singular[1..-1]}$"), plural[0,1].upcase + plural[1..-1])
            plural(Regexp.new("#{singular[0,1].downcase}(?i)#{singular[1..-1]}$"), plural[0,1].downcase + plural[1..-1])
            singular(Regexp.new("#{plural[0,1].upcase}(?i)#{plural[1..-1]}$"), singular[0,1].upcase + singular[1..-1])
            singular(Regexp.new("#{plural[0,1].downcase}(?i)#{plural[1..-1]}$"), singular[0,1].downcase + singular[1..-1])
          end
        end

        def uncountable(*words)
          (@uncountables << words).flatten!
        end
      end
    end
    
    def inflections
      if block_given?
        yield Inflections.instance
      else
        Inflections.instance
      end
    end
    
    def actorize(word)
      result = word.to_s.dup
      inflections.actors.each { |(rule, replacement)| break if result.gsub!(rule, replacement) } unless result.empty?
      result
    end
    
    unless defined?(ActiveSupport)
      def pluralize(word)
        result = word.to_s.dup

        if word.empty? || inflections.uncountables.include?(result.downcase)
          result
        else
          inflections.plurals.each { |(rule, replacement)| break if result.gsub!(rule, replacement) }
          result
        end
      end

      def singularize(word)
        result = word.to_s.dup

        if inflections.uncountables.include?(result.downcase)
          result
        else
          inflections.singulars.each { |(rule, replacement)| break if result.gsub!(rule, replacement) }
          result
        end
      end
    end
  end
  
  module StringExtensions
    def actorize
      Credentials::Inflector.actorize(self)
    end
    
    unless defined?(ActiveSupport)
      def pluralize
        Credentials::Inflector.pluralize(self)
      end
      
      def singularize
        Credentials::Inflector.singularize(self)
      end
    end
  end
end

String.send :include, Credentials::StringExtensions

Credentials::Inflector.inflections do |inflect|
  inflect.actor(/$/, 'er')
  inflect.actor(/e$/, 'er')
  inflect.actor(/ate$/, 'ator')
  inflect.actor(/([^aeiou])([aeiou])([^aeioux])$/, '\1\2\3\3er')
  inflect.actor(/ct$/, 'ctor')
  inflect.actor(/^(improvi[sz])e$/, '\1or')
  inflect.actor(/^(authori)[sz]e$/, '\1ty')
  inflect.actor(/^administer$/, 'administrator')
end
