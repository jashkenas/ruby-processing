module Processing
  module HelperMethods

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
      a = args[0]
      # convert to signed int
      if args.length == 1
        if a.is_a?(Fixnum) && a >= 2**31
          args = [ a - 2**32 ]
        elsif a.is_a?(String) && a[0].eql?('#')
          h = a[1..-1].rjust(6, '0').prepend('ff')
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
        fail ArgumentError, 'thread must be called with a block' , caller
      end
    end
    
     # explicitly provide 'processing.org' map instance method
    def map(value, start1, stop1, start2, stop2)
      start2 + (stop2 - start2) * ((value - start1).to_f / (stop1 - start1))
    end

    # explicitly provide 'processing.org' norm instance method
    def norm(value, start, stop)
      (value - start).to_f / (stop - start)
    end

    # explicitly provide 'processing.org' lerp instance method
    def lerp(start, stop, amt)
      start + (stop - start) * amt
    end

    # explicitly provide 'processing.org' min instance method
    # to return a float:- a, b and c need to be floats

    def min(*args)
      args.min { |a,b| a <=> b }
    end

    # explicitly provide 'processing.org' max instance method
    # to return a float:- a, b and c need to be floats

    def max(*args)
      args.max { |a, b| a <=> b }
    end
    
    def abs(val)
      warn 'abs(val) is deprecated use val.abs to avoid this warning'
      val.abs
    end

    def ceil(val)
      warn 'ceil(val) is deprecated use val.ceil to avoid this warning'
      val.ceil
    end

    def round(val)
      warn 'round(val) is deprecated use val.round to avoid this warning'
      val.round
    end

    # explicitly provide 'processing.org' dist instance method
    def dist(*args)
      alen = args.length
      return Math.hypot(args[0] - args[2], args[1] - args[3]) if alen == 4
      return Math.sqrt((args[0] - args[3]) * (args[0] - args[3]) +
          (args[1] - args[4]) * (args[1] - args[4]) +
          (args[2] - args[5]) * (args[2] - args[5])) if alen == 6
      fail ArgumentError, 'takes 4 or 6 parameters'
    end

    # explicitly provide 'processing.org' constrain instance method
    # to return a float:- amt, low and high need to be floats
    def constrain(amt, low, high)
      (amt < low) ? low : ((amt > high) ? high : amt)
    end

    # explicitly provide 'processing.org' pow instance method
    def pow(x, exp)
      warn 'pow(x, exp) is deprecated use x**exp to avoid this warning'
      x**exp
    end

    # explicitly provide 'processing.org' radians instance method
    def radians(theta)
      warn 'radians(theta) is deprecated use theta.radians to avoid this warning'
      theta.radians
    end
    
    # explicitly provide 'processing.org' hex instance method
    def hex(x)
      warn 'hex(x) is deprecated use x.hex to avoid this warning'
      x.hex
    end
    
     # explicitly provide 'processing.org' unhex instance method
    def unhex(str)
      warn 'unhex(str) is deprecated use str.to_i(base=16)'
      str.to_i(base=16)
    end
    
    # explicitly provide 'processing.org' hex instance method
    def binary(x)
      warn 'binary(x) is deprecated use x.to_s(2) to avoid this warning'
      x.hex
    end
    
    # explicitly provide 'processing.org' hex instance method
    def unhex(str)
      warn 'unbinary(str) is deprecated use str.to_i(base=2)'
      str.to_i(base=2)
    end
    
    # explicitly provide 'processing.org' nf instance method
    def nf(*args)
      warn 'nf(num, digits) is deprecated use num.to_s.rjust(digits) '\
        'to avoid this warning'
      if args.length == 2
        return args[0].to_s.rjust(args[1], '0')
      elsif args.length == 3
        return args[0].to_s.rjust(args[1], '0').ljust(args[1] + args[2], '0')
      else
        fail ArgumentError, 'takes 2 or 3 parameters'
      end
    end

    def mag(*vec)
      warn 'mag(x, y) is deprecated use hypot(x, y)'
      if vec.length == 2
        return hypot(vec[0], vec[1])
      elsif vec.length == 3
        return Math.sqrt(vec[0] * vec[0] + vec[1] * vec[1] + vec[2] * vec[2])
      else
        fail ArgumentError, 'takes 2 or 3 parameters'
      end
    end
    
    def trim(str)
      warn 'deprecated use str.strip'
      str.strip
    end

    def println(str)
      warn 'deprecated use puts(str)'
      puts str
    end
    
    def hour
      warn 'deprecated use t = Time.now and t.hour'
      PApplet.hour
    end
    
    def second
      warn 'deprecated use t = Time.now and t.sec'
      PApplet.second
    end
    
    def minute
       'deprecated use t = Time.now and t.min'
      PApplet.minute
    end
    
    # Uses PImage class method under hood
    def blend_color(c1, c2, mode)
      PImage.blendColor(c1, c2, mode)
    end

    # There's just so many functions in Processing,
    # Here's a convenient way to look for them.
    def find_method(method_name)
      reg = Regexp.new("#{method_name}", true)
      self.methods.sort.select { |meth| reg.match(meth) }
    end

    # Proxy over a list of Java declared fields that have the same name as
    # some methods. Add to this list as needed.
    def proxy_java_fields
      @declared_fields = {}
      fields = %w(sketchPath key frameRate frame mousePressed keyPressed)
      fields.each { |f| @declared_fields[f] = java_class.declared_field(f) }
    end

    # By default, your sketch path is the folder that your sketch is in.
    # If you'd like to do something fancy, feel free.
    def set_sketch_path(path = nil)
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
      @declared_fields['mousePressed'].value(java_self)
    end

    # Is a key pressed for this frame?
    def key_pressed?
      @declared_fields['keyPressed'].value(java_self)
    end
  end
end
