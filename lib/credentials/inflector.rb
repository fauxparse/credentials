module Credentials
  module Inflector
    def actorize(word)
      result = word.to_s.dup
      inflections.actors.each { |(rule, replacement)| break if result.gsub!(rule, replacement) } unless result.empty?
      result
    end
  end

  module Inflections
    attr_reader :actors

    def actors
      @actors ||= []
    end
    
    def actor(rule, replacement)
      actors.insert 0, [ rule, replacement ]
    end
  end
  
  module StringExtensions
    def actorize
      ActiveSupport::Inflector.actorize(self)
    end
  end
end

ActiveSupport::Inflector.send :extend, Credentials::Inflector
ActiveSupport::Inflector::Inflections.send :include, Credentials::Inflections
String.send :include, Credentials::StringExtensions

ActiveSupport::Inflector.inflections do |inflect|
  inflect.actor(/$/, 'er')
  inflect.actor(/e$/, 'er')
  inflect.actor(/ate$/, 'ator')
  inflect.actor(/([^aeiou])([aeiou])([^aeioux])$/, '\1\2\3\3er')
  inflect.actor(/ct$/, 'ctor')
  inflect.actor(/^(improvi[sz])e$/, '\1or')
  inflect.actor(/^(authori)[sz]e$/, '\1ty')
end
