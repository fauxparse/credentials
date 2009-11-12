require "credentials/extensions/object"

if defined?("ActionController")
  require "credentials/extensions/action_controller"
  ActionController::Base.send :include, Credentials::Extensions::ActionController
end
