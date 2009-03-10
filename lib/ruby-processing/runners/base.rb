$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../")
require 'ruby-processing'
require 'ruby-processing/app'

module Processing
  SKETCH_PATH = ARGV[0]
end