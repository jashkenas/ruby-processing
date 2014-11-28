# -*- encoding : utf-8 -*-

SKETCH_PATH ||= ARGV.shift
SKETCH_ROOT ||= File.dirname(SKETCH_PATH)

require_relative '../../ruby-processing'
require_relative '../../ruby-processing/app'

module Processing
  # For use with "bare" sketches that don't want to define a class or methods
  BARE_TEMPLATE = <<-EOS
  class Sketch < Processing::App
    %s
  end
  EOS

  NAKED_TEMPLATE = <<-EOS
  class Sketch < Processing::App
    def setup
      size(DEFAULT_WIDTH, DEFAULT_HEIGHT)
      %s
      no_loop
    end
  end
  EOS

  # This method is the common entry point to run a sketch, bare or complete.
  def self.load_and_run_sketch
    source = read_sketch_source
    has_sketch = !source.match(/^[^#]*< Processing::App/).nil?
    has_methods = !source.match(/^[^#]*(def\s+setup|def\s+draw)/).nil?

    return load File.join(SKETCH_ROOT, SKETCH_PATH) if has_sketch
    if has_methods
      code = format(BARE_TEMPLATE, source)
    else
      code = format(NAKED_TEMPLATE, source)
    end
    Object.class_eval code, SKETCH_PATH, -1
    Processing::App.sketch_class.new
  end

  # Read in the sketch source code. Needs to work both online and offline.
  def self.read_sketch_source
    File.read(SKETCH_PATH)
  end
end
