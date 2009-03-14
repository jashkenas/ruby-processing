$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../")
SKETCH_ROOT = File.dirname(ARGV[0]) unless defined? SKETCH_ROOT

require 'ruby-processing'
require 'ruby-processing/app'


module Processing
  
  SKETCH_PATH = ARGV[0]
  
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
    source = File.read(Processing::SKETCH_PATH)
    has_sketch = !!source.match(/^[^#]*< Processing::App/)
    has_methods = !!source.match(/^[^#]*def setup/)
    
    if has_sketch
      load Processing::SKETCH_PATH
      Processing::App.sketch_class.new if !$app
      return
    else
      require 'erb'
      code = ERB.new(SKETCH_TEMPLATE).result(binding)
      Object.class_eval code, Processing::SKETCH_PATH, 0
      Processing::App.sketch_class.new if !$app
    end
  end
  
end