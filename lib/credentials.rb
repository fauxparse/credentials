require "credentials/actor"
require "credentials/rulebook"
require "credentials/class_methods"
require "credentials/inflector"

Object.send :extend, Credentials::ClassMethods
