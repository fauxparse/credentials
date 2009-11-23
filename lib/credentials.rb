require "credentials/rulebook"
require "credentials/extensions/object"

Object.send :include, Credentials::Extensions::Object
