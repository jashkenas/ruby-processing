$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../")
require 'ruby-processing'
require 'ruby-processing/app'

SKETCH_ROOT = File.dirname(ARGV[0]) unless defined? SKETCH_ROOT

module Processing
  SKETCH_PATH = ARGV[0]
end