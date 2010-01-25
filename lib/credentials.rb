require "credentials/rulebook"
require "credentials/extensions/object"
require "credentials/extensions/magic_methods"

module Credentials
  Prepositions = [ :on, :for, :with, :at, :in, :from ].freeze
end

Object.send :include, Credentials::Extensions::Object

if defined?(ActionController)
  ActionController::Base.send :include, Credentials::Extensions::ActionController
end

unless defined?(ActiveSupport)
  class String
    if Module.method(:const_get).arity == 1
      def constantize
        names = split('::')
        names.shift if names.empty? || names.first.empty?

        constant = Object
        names.each do |name|
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
        end
        constant
      end
    else
      def constantize
        names = split('::')
        names.shift if names.empty? || names.first.empty?

        constant = Object
        names.each do |name|
          constant = constant.const_get(name, false) || constant.const_missing(name)
        end
        constant
      end
    end
  end
end
