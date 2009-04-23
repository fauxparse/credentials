require "credentials/actor"
require "credentials/rulebook"
require "credentials/class_methods"
require "credentials/inflector"
require "credentials/rules/rule"
Dir.glob(File.dirname(__FILE__) + "/credentials/rules/*.rb").each { |f| require f }
Dir.glob(File.dirname(__FILE__) + "/credentials/support/*.rb").each { |f| require f } unless defined?(ActiveSupport)

Object.send :extend, Credentials::ClassMethods
