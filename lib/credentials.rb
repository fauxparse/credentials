require "credentials/rulebook"
require "credentials/extensions/object"
require "credentials/extensions/magic_methods"

module Credentials
  Prepositions = [ :on, :for, :with, :at, :in ].freeze
end

Object.send :include, Credentials::Extensions::Object

if defined?(ActionController)
  ActionController::Base.send :include, Credentials::Extensions::ActionController
end
