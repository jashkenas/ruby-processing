# -*- encoding : utf-8 -*-

SKETCH_PATH ||= ARGV.shift
SKETCH_ROOT ||= File.dirname(SKETCH_PATH)

require_relative '../../ruby-processing'
require_relative '../../ruby-processing/app'

module Processing
  # For use with "bare" sketches that don't want to define a class or methods
  SKETCH_TEMPLATE = <<-EOS
  class Sketch < Processing::App
  <% if has_methods %>
  <%= source %>
  <% else %>
  def setup
  size(DEFAULT_WIDTH, DEFAULT_HEIGHT, JAVA2D)
  <%= source %>
  no_loop
  end
  <% end %>
  end
  EOS

  # This method is the common entry point to run a sketch, bare or complete.
  def self.load_and_run_sketch
    source = read_sketch_source
    has_sketch = !source.match(/^[^#]*< Processing::App/).nil?
    has_methods = !source.match(/^[^#]*(def\s+setup|def\s+draw)/).nil?

    if has_sketch
      load File.join(SKETCH_ROOT, SKETCH_PATH)
      Processing::App.sketch_class.new unless $app
    else
      require 'erb'
      code = ERB.new(SKETCH_TEMPLATE).result(binding)
      Object.class_eval code, SKETCH_PATH, -1
      Processing::App.sketch_class.new
    end
  end

  # Read in the sketch source code. Needs to work both online and offline.
  def self.read_sketch_source
    File.read(SKETCH_PATH)
  end
end
