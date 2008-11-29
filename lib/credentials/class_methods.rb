module Credentials
  module ClassMethods
    # Defines the set of credentials common to members of a class.
    #--
    # TODO merge options properly in subclasses instead of overwriting
    def has_credentials(options = {}, &block)
      unless included_modules.include? Actor
        write_inheritable_attribute :credentials, []
        class_inheritable_reader :credentials
        class_inheritable_reader :credentials_options
        include Actor
      end
      write_inheritable_attribute :credentials_options, (read_inheritable_attribute(:credentials_options) || {}).merge(options)
      instance_eval &block if block_given?
    end
  end
end

ActiveRecord::Base.send :extend, Credentials::ClassMethods
