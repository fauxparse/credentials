# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{credentials}
  s.version = "2.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Powell"]
  s.date = %q{2009-11-24}
  s.description = %q{A generic actor/resource permission framework based on rules, not objects.}
  s.email = %q{fauxparse@gmail.com.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "HISTORY",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "credentials.gemspec",
     "init.rb",
     "install.rb",
     "lib/credentials.rb",
     "lib/credentials/allow_rule.rb",
     "lib/credentials/deny_rule.rb",
     "lib/credentials/errors.rb",
     "lib/credentials/extensions/action_controller.rb",
     "lib/credentials/extensions/configuration.rb",
     "lib/credentials/extensions/object.rb",
     "lib/credentials/rule.rb",
     "lib/credentials/rulebook.rb",
     "spec/.gitignore",
     "spec/controllers/test_controller_spec.rb",
     "spec/credentials_spec.rb",
     "spec/domain.rb",
     "spec/rule_spec.rb",
     "spec/rulebook_spec.rb",
     "spec/spec_helper.rb",
     "tasks/gems.rake",
     "tasks/rdoc.rake",
     "tasks/spec.rake",
     "tasks/stats.rake",
     "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/fauxparse/credentials}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A generic actor/resource permission framework based on rules, not objects.}
  s.test_files = [
    "spec/controllers/test_controller_spec.rb",
     "spec/credentials_spec.rb",
     "spec/domain.rb",
     "spec/rule_spec.rb",
     "spec/rulebook_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

