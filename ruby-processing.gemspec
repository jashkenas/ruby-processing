# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-processing/version'
require 'rake'

Gem::Specification.new do |spec|
  spec.name = "ruby-processing"
  spec.version = RubyProcessing::VERSION
  spec.authors = %w(Jeremy\ Ashkenas Peter\ Gassner\ Martin\ Stannard\ Andrew\ Nanton
                Marc\ Chung Peter\ Krenn Florian\ Jenett Andreas\ Haller
               Juris\ Galang Guillaume\ Pierronnet Martin\ Prout)
  spec.email = "jeremy@ashkenas.com"
  spec.description = <<-EOS
  Ruby-Processing is a ruby wrapper for the processing-2.0 art framework.
  This version supports processing-2.2.1, and uses jruby-complete-1.7.25 or an 
  installed jruby as the glue between ruby and java. Use both processing 
  libraries and ruby gems in your sketches. The "watch" mode, provides a 
  nice REPL-ish way to work on your processing sketches. Features a polyglot
  maven build, opening the way to use/test latest jruby.
  EOS
  spec.summary = %q{Code as Art, Art as Code. Processing and Ruby are meant for each other.}
  spec.homepage = "http://wiki.github.com/jashkenas/ruby-processing"
  spec.post_install_message = %q{Use 'rp5 setup install' to install jruby-complete, and 'rp5 setup check' to check config.}
  spec.license = 'MIT'

  spec.files = FileList['bin/**/*', 'lib/**/*', 'library/**/*', 'samples/**/*', 'vendors/Rakefile'].exclude(/jar/).to_a
  spec.files << 'lib/rpextras.jar'

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.requirements << 'A decent graphics card'
  spec.requirements << 'java runtime >= 1.7+'
  spec.requirements << 'processing = 2.2.1'
end

