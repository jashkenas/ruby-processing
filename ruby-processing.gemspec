require 'rake'

Gem::Specification.new do |s|
  s.name = "ruby-processing"
  s.version = "1.0.1"
  
  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Ashkenas", "Peter Gassner", "Martin Stannard", "Andrew Nanton"]
  s.date = "2009-1-16"
  s.default_executable = "rp5"
  s.email = "jeremy@ashkenas.com"
  s.executables = ["rp5"]
  s.extra_rdoc_files = ["README", "CHANGELOG", "LICENSE"]
  s.files = FileList['bin/**/*', 'lib/**/*', 'library/**/*', 'samples/**/*'].to_a
  s.has_rdoc = true
  s.homepage = "http://wiki.github.com/jashkenas/ruby-processing"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ruby-Processing", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "ruby-processing"
  s.summary = "Code as Art, Art as Code. Processing and Ruby are meant for each other."
  s.description = <<-EOS
  
  Ruby-Processing is a Ruby wrapper for the Processing code art framework. It's
  this thin little shim that squeezes between Processing and JRuby, passing 
  along some neat goodies like:
  
  * Applet and Application exporting of your sketches. Hand them out to 
    your party guests, ready-to-run.
    
  * Live Coding via JRuby's IRB. Loads in your sketch so you can futz with 
    variables and remake methods on the fly.
    
  * A "Control Panel" library, so that you can easily create sliders, buttons,
    checkboxes and drop-down menus, and hook them into your sketch's instance 
    variables.
    
  * "Watch" mode, where Ruby-Processing keeps an eye on your sketch and reloads 
    it from scratch every time you make a change. A pretty nice REPL-ish way
    to work on your Processing sketches.
  
  EOS
end
