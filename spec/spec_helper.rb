$: << File.dirname(__FILE__) + "/../lib"
require "rails/boot.rb"
require "credentials"
require "spec"
require "date"

require File.join(File.dirname(__FILE__), "domain.rb")
Dir[File.dirname(__FILE__) + '/rails/controllers/*.rb'].each { |f| require f }
