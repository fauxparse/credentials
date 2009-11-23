require "credentials/rulebook"
require "credentials/extensions/object"

Object.send :include, Credentials::Extensions::Object

if defined?(ActionController)
  ActionController::Base.send :include, Credentials::Extensions::ActionController
end
