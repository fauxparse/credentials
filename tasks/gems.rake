require 'rubygems'  
require 'rake'  
  
begin  
  require 'jeweler'  
  Jeweler::Tasks.new do |gemspec|  
    gemspec.name = "credentials"  
    gemspec.summary = "A generic actor/resource permission framework based on rules, not objects."  
    gemspec.description = "A generic actor/resource permission framework based on rules, not objects."  
    gemspec.email = "fauxparse@gmail.com.com"  
    gemspec.homepage = "http://github.com/fauxparse/credentials"  
    gemspec.authors = ["Matt Powell"]  
  end
  Jeweler::GemcutterTasks.new
rescue LoadError  
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"  
end  