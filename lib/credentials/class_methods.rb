module Credentials
  module ClassMethods
    # Defines the set of credentials common to members of a class.
    def credentials(options = {}, &block)
      unless included_modules.include? Actor
        class_inheritable_reader :rulebook
        class_inheritable_reader :credential_options
        include Actor
      end
      write_inheritable_attribute :credential_options, merge_credential_options(read_inheritable_attribute(:credential_options), options)
      old_rulebook = read_inheritable_attribute(:rulebook)
      write_inheritable_attribute :rulebook, Rulebook.new(self, old_rulebook ? old_rulebook.rules : [])
      yield rulebook if block_given?
    end
    
  protected
    # Merges the set of options inherited from a parent class (if any)
    def merge_credential_options(a, b)
      a ||= {}
      b ||= {}
      a[:groups] = (Array(a[:groups]) + Array(b.delete(:groups))).uniq if b[:groups]
      a.merge(b)
    end
  end
end

ActiveRecord::Base.send :extend, Credentials::ClassMethods
