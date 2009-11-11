begin
  require 'hanna/rdoctask'
rescue
  require 'rake/rdoctask'
end

desc 'Generate RDoc documentation.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_files.include('README.rdoc', 'LICENSE').
    include('lib/**/*.rb')

  rdoc.main = "README.rdoc" # page to start on
  rdoc.title = "credentials documentation"

  rdoc.rdoc_dir = 'doc' # rdoc output folder
  rdoc.options << '--webcvs=http://github.com/fauxparse/credentials/'
end