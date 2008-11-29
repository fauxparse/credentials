module Credentials
  module ClassMethods
    def has_credentials(&block)
      unless included_modules.include? Actor
        write_inheritable_attribute :credentials, []
        class_inheritable_reader :credentials
        
        include Actor
      end
      instance_eval &block if block_given?
    end
  end
end

ActiveRecord::Base.send :extend, Credentials::ClassMethods
