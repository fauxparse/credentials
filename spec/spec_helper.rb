begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "NOTE: install rspec in your base app to test Rails integration"
  $: << File.dirname(__FILE__) + "/../lib"
  require "credentials"
  require "spec"
  require "date"
end

require File.join(File.dirname(__FILE__), "domain.rb")
