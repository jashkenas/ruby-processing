$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../")
SKETCH_PATH = ARGV.shift
SKETCH_ROOT = File.dirname(SKETCH_PATH) unless defined? SKETCH_ROOT

require 'ruby-processing'
require 'ruby-processing/app'


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
    source = self.read_sketch_source
    has_sketch = !!source.match(/^[^#]*< Processing::App/)
    has_methods = !!source.match(/^[^#]*(def\s+setup|def\s+draw)/)
    
    if has_sketch
      load SKETCH_PATH
      Processing::App.sketch_class.new if !$app
      return
    else
      require 'erb'
      code = ERB.new(SKETCH_TEMPLATE).result(binding)
      Object.class_eval code, SKETCH_PATH, 0
      Processing::App.sketch_class.new if !$app
    end
  end
  
  
  # Read in the sketch source code. Needs to work both online and offline.
  def self.read_sketch_source
    if Processing.online?
      # Fuck the following lines. Fucking Java can go sit on broken glass.
      source = ''
      url = java.net.URL.new(JRUBY_APPLET.get_code_base, SKETCH_PATH)
      input = java.io.BufferedReader.new(java.io.InputStreamReader.new(url.open_stream))
      while line = input.read_line do
        source << (line + "\n") if line
      end
      input.close
    else
      # Ahhh, much better.
      source = File.read(SKETCH_PATH)
    end
    source
  end
  
end