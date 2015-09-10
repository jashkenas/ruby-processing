# processing module wrapper
require_relative '../rpextras'


module Processing
  # Provides some convenience methods available in vanilla processing
  Java::Monkstone::MathToolLibrary.load(JRuby.runtime)
  module HelperMethods
    # processings epsilon may not be defined yet
    EPSILON ||= 1.0e-04
    # Nice block method to draw to a buffer.
    # You can optionally pass it a width, a height, and a renderer.
    # Takes care of starting and ending the draw for you.
    def buffer(buf_width = width, buf_height = height, renderer = @render_mode)
      buf = create_graphics(buf_width, buf_height, renderer)
      buf.begin_draw
      yield buf
      buf.end_draw
      buf
    end

    # A nice method to run a given block for a grid.
    # Lifted from action_coding/Nodebox.
    def grid(cols, rows, col_size = 1, row_size = 1)
      (0...cols * rows).map do |i|
        x = col_size * (i % cols)
        y = row_size * i.div(cols)
        yield x, y
      end
    end

    # lerp_color takes three or four arguments, in Java that's two
    # different methods, one regular and one static, so:
    def lerp_color(*args)
      args.length > 3 ? self.class.lerp_color(*args) : super(*args)
    end

    def color(*args)
      return super(*args) unless args.length == 1
      super(hex_color(args[0]))
    end

    # Overrides Processing convenience function thread, which takes a String
    # arg (for a function) to more rubylike version, takes a block...
    def thread(&block)
      if block_given?
        Thread.new(&block)
      else
        fail ArgumentError, 'thread must be called with a block', caller
      end
    end

    # explicitly provide 'processing.org' min instance method
    # to return a float:- a, b and c need to be floats

    def min(*args)
      args.min  #  { |a,b| a <=> b } optional block not reqd
    end

    # explicitly provide 'processing.org' max instance method
    # to return a float:- a, b and c need to be floats

    def max(*args)
      args.max  #  { |a, b| a <=> b } optional block not reqd
    end

    # explicitly provide 'processing.org' dist instance method
    def dist(*args)
      len = args.length
      if len == 4
        return dist2d(*args)
      elsif len == 6
        return dist3d(*args)
      end
      fail ArgumentError, 'takes 4 or 6 parameters'
    end

    # Uses PImage class method under hood
    def blend_color(c1, c2, mode)
      Java::ProcessingCore::PImage.blendColor(c1, c2, mode)
    end

    # There's just so many functions in Processing,
    # Here's a convenient way to look for them.
    def find_method(method_name)
      reg = Regexp.new("#{method_name}", true)
      methods.sort.select { |meth| reg.match(meth) }
    end

    # Proxy over a list of Java declared fields that have the same name as
    # some methods. Add to this list as needed.
    def proxy_java_fields
      fields = %w(sketchPath key frameRate frame mousePressed keyPressed)
      methods  = fields.map { |field| java_class.declared_field(field) }
      @declared_fields = Hash[fields.zip(methods)]
    end
    
    class VersionError < StandardError
    end

    # By default, your sketch path is the folder that your sketch is in.
    # If you'd like to do something fancy, feel free.
    def set_sketch_path(spath = nil)
      field = @declared_fields['sketchPath']
      begin
        field.set_value(java_self, spath || SKETCH_ROOT)
      rescue TypeError
        fail VersionError, 'Use JRubyArt for processing-3.0'
      end
    end

    # Fix java conversion problems getting the last key
    # If it's ASCII, return the character, otherwise the integer
    def key
      int = @declared_fields['key'].value(java_self)
      int < 256 ? int.chr : int
    end

    # Provide a convenient handle for the Java-space version of self.
    def java_self
      @java_self ||= to_java(Java::ProcessingCore::PApplet)
    end

    # Get the sketch path
    def sketch_path
      @declared_fields['sketchPath'].value(java_self)
    end

    # Fields that should be made accessible as under_scored.
    define_method(:mouse_x) { mouseX }

    define_method(:mouse_y) { mouseY }

    define_method(:pmouse_x) { pmouseX }

    define_method(:pmouse_y) { pmouseY }

    define_method(:frame_count) { frameCount }

    define_method(:mouse_button) { mouseButton }

    define_method(:key_code) { keyCode }

    # Ensure that load_strings returns a real Ruby array
    def load_strings(file_or_url)
      loadStrings(file_or_url).to_a
    end

    # Writes an array of strings to a file, one line per string.
    # This file is saved to the sketch's data folder
    def save_strings(filename, strings)
      saveStrings(filename, [strings].flatten.to_java(:String))
    end

    # frame_rate needs to support reading and writing
    def frame_rate(fps = nil)
      return @declared_fields['frameRate'].value(java_self) unless fps
      super(fps)
    end

    # Is the mouse pressed for this frame?
    def mouse_pressed?
      @declared_fields['mousePressed'].value(java_self)
    end

    # Is a key pressed for this frame?
    def key_pressed?
      @declared_fields['keyPressed'].value(java_self)
    end

    private

    # parse single argument color int/double/String
    def hex_color(a)
      if a.is_a?(Fixnum)
        return Java::Monkstone::ColorUtil.colorLong(a)
      elsif a.is_a?(String)
        return Java::Monkstone::ColorUtil.colorString(a) if a =~ /#\h+/
        fail StandardError, 'Dodgy Hexstring'
      end
      Java::Monkstone::ColorUtil.colorDouble(a)
    end

    def dist2d(*args)
      dx = args[0] - args[2]
      dy = args[1] - args[3]
      return 0 if dx.abs < EPSILON && dy.abs < EPSILON
      Math.hypot(dx, dy)
    end

    def dist3d(*args)
      dx = args[0] - args[3]
      dy = args[1] - args[4]
      dz = args[2] - args[5]
      return 0 if dx.abs < EPSILON && dy.abs < EPSILON && dz.abs < EPSILON
      Math.sqrt(dx * dx + dy * dy + dz * dz)
    end
  end
end
