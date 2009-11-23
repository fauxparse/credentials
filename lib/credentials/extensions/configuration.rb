module Credentials #:nodoc:
  module Extensions #:nodoc:
    module Configuration #:nodoc:
      def rw_config(key, value, default_value = nil, read_value = nil)
        if value == read_value
          inheritable_attributes.include?(key) ? read_inheritable_attribute(key) : default_value
        else
          write_inheritable_attribute(key, value)
        end
      end
    end
  end
end
