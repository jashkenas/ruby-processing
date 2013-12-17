# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-processing/version'

Gem::Specification.new do |spec|
  spec.name = "ruby-processing"
  spec.version = RubyProcessing::VERSION
  spec.authors = ["Jeremy Ashkenas", "Peter Gassner", "Martin Stannard", "Andrew Nanton",
               "Marc Chung", "Peter Krenn", "Florian Jenett", "Andreas Haller",
               "Juris Galang", "Guillaume Pierronnet", "Martin Prout"]
  spec.email = "jeremy@ashkenas.com"
  spec.description = <<-EOS

  Ruby-Processing is a Ruby wrapper for the Processing code art framework. It's
  this thin little shim that squeezes between Processing and JRuby, passing
  along some neat goodies like:

  * Application exporting of your sketches. Hand them out to your party guests, 
    ready-to-run.

  * Live Coding via JRuby's IRB. Loads in your sketch so you can futz with
    variables and remake methods on the fly.

  * Bare sketches. Write your Ruby-Processing sketches without having to define
    a class. Without defining methods, even.

  * A "Control Panel" library, so that you can easily create sliders, buttons,
    checkboxes and drop-down menus, and hook them into your sketch's instance
    variables.

  * "Watch" mode, where Ruby-Processing keeps an eye on your sketch and reloads
    it from scratch every time you make a change. A pretty nice REPL-ish way
    to work on your Processing sketches.

  EOS
  spec.summary = %q{Code as Art, Art as Code. Processing and Ruby are meant for each other.}
  spec.homepage = "http://wiki.github.com/jashkenas/ruby-processing"
  spec.executables = ["rp5", "install_jruby_complete"]
  spec.license = 'MIT'
  
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'minitest'
  spec.requirements << 'A decent graphics card'
  spec.requirements << 'java runtime >= 1.6+'
  spec.requirements << 'processing = 2.0.3+'
 
end

