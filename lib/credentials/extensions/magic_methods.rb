module Credentials
  module Extensions
    # Allows you to use magic methods to test permissions.
    # For example:
    #
    #     class User
    #       credentials do |user|
    #         user.can :edit, :self
    #       end
    #     end
    #     
    #     user = User.new
    #     user.can_edit? user #=> true
    module MagicMethods
      # def self.included(receiver) #:nodoc:
      #   receiver.class_eval do
      #     def method_missing(sym, *args)
      #       if self.class != Object && self.class != Class && sym.to_s =~ /\Acan_(.*)\?\z/
      #         can? $1.to_sym, *args
      #       else
      #         super
      #       end
      #     end
      #   end
      # end
    end
  end
end