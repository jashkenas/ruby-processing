# Windows apps start life in the wrong folder.
ARGV[1] = nil and Dir.chdir('lib') if ARGV[1] == '--windows-app'

require "#{File.dirname(__FILE__)}/base.rb"
require Processing::SKETCH_PATH