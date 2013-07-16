module Processing
  module HelperMethods

    # Nice block method to draw to a buffer.
    # You can optionally pass it a width, a height, and a renderer.
    # Takes care of starting and ending the draw for you.
    def buffer(buf_width=width, buf_height=height, renderer=@render_mode)
      buf = create_graphics(buf_width, buf_height, renderer)
      buf.begin_draw
      yield buf
      buf.end_draw
      buf
    end

    # A nice method to run a given block for a grid.
    # Lifted from action_coding/Nodebox.
    def grid(cols, rows, col_size=1, row_size=1)
      (0...cols*rows).map do |i|
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
      a = args[0]
      # convert to signed int
      if args.length == 1 
        if a.is_a?(Fixnum) && a >= 2**31
          args = [ a - 2**32 ]
        elsif a.is_a?(String) && a[0] == ?#
          h = a[1..-1]
          # add opaque alpha channel
          if h.size <= 6
            h = "ff" + "0"*(6-h.size) + h
          end
          return color(h.hex)
        end
      end
      super(*args)
    end
    
    # Overrides convenience function loop, to add ability to loop over a block 
    # if supplied, otherwise perform as the PApplet class would
    def loop(&block)
      if block_given?
        while true do
          yield
        end
      else
        super
      end
    end
    
    # Overrides Processing convenience function thread, which takes a String
    # arg (for a function) to more rubylike version, takes a block...    
    def thread(*args, &block)
      if block_given?
        Thread.new *args, &block
      else
        raise ArgumentError, "thread must be called with a block" , caller    
      end
    end

    # There's just so many functions in Processing,
    # Here's a convenient way to look for them.
    def find_method(method_name)
      reg = Regexp.new("#{method_name}", true)
      self.methods.sort.select {|meth| reg.match(meth)}
    end

    # Proxy over a list of Java declared fields that have the same name as
    # some methods. Add to this list as needed.
    def proxy_java_fields
      @declared_fields = {}
      fields = %w(sketchPath key frameRate frame mousePressed keyPressed)
      fields.each {|f| @declared_fields[f] = java_class.declared_field(f) }
    end

    # By default, your sketch path is the folder that your sketch is in.
    # If you'd like to do something fancy, feel free.
    def set_sketch_path(path=nil)
      field = @declared_fields['sketchPath']
      field.set_value(java_self, path || SKETCH_ROOT)
    end



    # Fix java conversion problems getting the last key
    # If it's ASCII, return the character, otherwise the integer
    def key
      int = @declared_fields['key'].value(java_self)
      int < 256 ? int.chr : int
    end

    # Provide a convenient handle for the Java-space version of self.
    def java_self
      @java_self ||= self.to_java(Java::ProcessingCore::PApplet)
    end


    # Get the sketch path
    def sketch_path
      @declared_fields['sketchPath'].value(java_self)
    end

    # Fields that should be made accessible as under_scored.
    def mouse_x;      mouseX;       end
    def mouse_y;      mouseY;       end
    def pmouse_x;     pmouseX;      end
    def pmouse_y;     pmouseY;      end
    def frame_count;  frameCount;   end
    def mouse_button; mouseButton;  end
    def key_code;     keyCode;      end


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
      field =  @declared_fields['mousePressed'].value(java_self)
    end

    # Is a key pressed for this frame?
    def key_pressed? 
      field =  @declared_fields['keyPressed'].value(java_self)
    end
  end
end
