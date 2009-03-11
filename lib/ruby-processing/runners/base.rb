$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../")
SKETCH_ROOT = File.dirname(ARGV[0]) unless defined? SKETCH_ROOT

require 'ruby-processing'
require 'ruby-processing/app'

module Processing
  SKETCH_PATH = ARGV[0]
end