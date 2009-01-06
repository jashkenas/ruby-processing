$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../")
module Processing
  SKETCH_PATH = ARGV[0]
end
require Processing::SKETCH_PATH