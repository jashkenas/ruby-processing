require 'rake'

Gem::Specification.new do |s|
  s.name = "ruby-processing"
  s.version = "1.1"
  
  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Ashkenas", "Peter Gassner", "Martin Stannard", "Andrew Nanton"]
  s.date = "2008-12-31"
  s.default_executable = "rp5"
  s.description = "Code as Art, Art as Code. Processing and Ruby are meant for each other."
  s.email = "jeremy@ashkenas.com"
  s.executables = ["rp5"]
  s.extra_rdoc_files = ["README", "CHANGELOG", "LICENSE"]
  s.files = FileList['bin/**/*', 'lib/**/*', 'library/**/*', 'samples/**/*'].to_a
  s.has_rdoc = true
  s.homepage = "http://github.com/jashkenas/ruby-processing/wikis"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ruby-Processing", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "ruby-processing"
  s.summary = "Code as Art, Art as Code. Processing and Ruby are meant for each other."
end
