# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{credentials}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Powell"]
  s.date = %q{2009-04-23}
  s.description = %q{Credentials is a generic actor/resource permission framework based on rules, not objects.}
  s.email = %q{fauxparse@gmail.com}
  s.files = ["generators", "generators/credentials", "generators/credentials/credentials_generator.rb", "generators/credentials/templates", "generators/credentials/USAGE", "History.txt", "init.rb", "install.rb", "lib", "lib/credentials", "lib/credentials/actor.rb", "lib/credentials/class_methods.rb", "lib/credentials/inflector.rb", "lib/credentials/rulebook.rb", "lib/credentials/rules", "lib/credentials/rules/can.rb", "lib/credentials/rules/cannot.rb", "lib/credentials/rules/rule.rb", "lib/credentials.rb", "LICENSE", "Manifest.txt", "Rakefile", "README.rdoc", "uninstall.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/fauxparse/credentials}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{credentials}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Credentials is a generic actor/resource permission framework based on rules, not objects.}
end
