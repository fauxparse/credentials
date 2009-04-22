# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/credentials.rb'

Hoe.new('credentials', Credentials::VERSION) do |p|
  # p.rubyforge_name = 'credentialsx' # if different than lowercase project name
  p.developer('Matt Powell', 'fauxparse@gmail.com')
end

# vim: syntax=Ruby

require 'rake'
require 'spec/rake/spectask'
require 'rcov/rcovtask'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--colour --format progress --loadby mtime --reverse']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Output test coverage of plugin.'
Rcov::RcovTask.new(:rcov) do |rcov|
  rcov.pattern    = 'spec/**/*_spec.rb'
  rcov.output_dir = 'rcov'
  rcov.verbose    = true
  rcov.rcov_opts << '--exclude "test_app/config/*"'
end
