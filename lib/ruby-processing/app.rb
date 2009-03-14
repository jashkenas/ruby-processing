# This class is a thin wrapper around Processing's PApplet.
# Most of the code here is for interfacing with Swing, 
# web applets, going fullscreen and so on.

require 'java'

module Processing   

  # Conditionally load core.jar
  require "#{RP5_ROOT}/lib/core/core.jar" unless Object.const_defined?(:JRUBY_APPLET)  
  import "processing.core"

  # This is the main Ruby-Processing class, and is what you'll
  # inherit from when you create a sketch. This class can call
  # all of the methods available in Processing, and has two 
  # mandatory methods, 'setup' and 'draw', both of which you
  # should define in your sketch. 'setup' will be called one
  # time when the sketch is first loaded, and 'draw' will be 
  # called constantly, for every frame.
  class App < PApplet
    include Math
    
    # Include some processing classes that we'd like to use:
    %w(PShape PImage PGraphics PFont PVector).each do |klass|
      import "processing.core.#{klass}"
    end
        
    # Alias some methods for familiarity for Shoes coders.
    attr_accessor :frame, :title
    alias_method :oval, :ellipse
    alias_method :stroke_width, :stroke_weight
    alias_method :rgb, :color
    alias_method :gray, :color

    # Watch the definition of these methods, to make sure 
    # that Processing is able to call them during events.
    METHODS_TO_WATCH_FOR = { 
      :mouse_pressed  => :mousePressed,
      :mouse_dragged  => :mouseDragged,
      :mouse_clicked  => :mouseClicked,
      :mouse_moved    => :mouseMoved, 
      :mouse_released => :mouseReleased,
      :key_pressed    => :keyPressed,
      :key_released   => :keyReleased,
      :key_typed      => :keyTyped 
    }


    def self.method_added(method_name) #:nodoc:
      if METHODS_TO_WATCH_FOR.keys.include?(method_name)
        alias_method METHODS_TO_WATCH_FOR[method_name], method_name
      end
    end


    # Class methods that we should make available in the instance.
    [:map, :pow, :norm, :lerp, :second, :minute, :hour, :day, :month, :year, 
     :sq, :constrain, :dist, :blend_color, :degrees, :radians, :mag].each do |meth|
      method = <<-EOS
        def #{meth}(*args)
          self.class.#{meth}(*args)
        end
      EOS
      eval method
    end
    

    # Handy getters and setters on the class go here:
    def self.sketch_class; @sketch_class; end 
    
    
    # Keep track of what inherits from the Processing::App, because we're going
    # to want to instantiate one.
    def self.inherited(subclass)
      super(subclass)
      @sketch_class = subclass
    end
    

    # Are we running inside an applet?
    def self.online?
      @online ||= Object.const_defined?(:JRUBY_APPLET)
    end
    def online?; self.class.online?; end


    # Detect if a library has been loaded (for conditional loading)
    @@loaded_libraries = Hash.new(false)
    def self.library_loaded?(folder)
      @@loaded_libraries[folder.to_sym]
    end
    def library_loaded?(folder); self.class.library_loaded?(folder); end
    
    
    # Load a list of Ruby or Java libraries (in that order)
    # Usage: load_libraries :opengl, :boids
    #
    # If a library is put into a 'library' folder next to the sketch it will
    # be used instead of the library that ships with Ruby-Processing.
    def self.load_libraries(*args)
      args.each {|lib| load_ruby_library(lib) || load_java_library(lib) }
    end
    def self.load_library(*args); self.load_libraries(*args); end


    # For pure ruby libraries.
    # The library should have an initialization ruby file 
    # of the same name as the library folder.
    def self.load_ruby_library(dir)
      dir = dir.to_sym
      return true if @@loaded_libraries[dir]
      if online?
        begin
          return @@loaded_libraries[dir] = (require "library/#{dir}/#{dir}")
        rescue LoadError => e
          return false
        end
      end
      local_path = "#{SKETCH_ROOT}/library/#{dir}"
      gem_path = "#{RP5_ROOT}/library/#{dir}"
      path = File.exists?(local_path) ? local_path : gem_path
      return false unless (File.exists?("#{path}/#{dir}.rb"))
      return @@loaded_libraries[dir] = (require "#{path}/#{dir}")
    end


    # For pure java libraries, such as the ones that are available
    # on this page: http://processing.org/reference/libraries/index.html
    #
    # P.S. -- Loading libraries which include native code needs to 
    # hack the Java ClassLoader, so that you don't have to 
    # futz with your PATH. But it's probably bad juju.
    def self.load_java_library(dir)
      dir = dir.to_sym
      return true if @@loaded_libraries[dir]
      return @@loaded_libraries[dir] = !!(JRUBY_APPLET.get_parameter("archive").match(%r(#{dir}))) if online?
      local_path = "#{SKETCH_ROOT}/library/#{dir}"
      gem_path = "#{RP5_ROOT}/library/#{dir}"
      path = File.exists?(local_path) ? local_path : gem_path
      jars = Dir["#{path}/**/*.jar"]
      return false if jars.empty?
      jars.each {|jar| require jar }
      # Here goes...
      library_path = java.lang.System.getProperty("java.library.path")
      new_library_path = [path, "#{path}/library", library_path].join(java.io.File.pathSeparator)
      java.lang.System.setProperty("java.library.path", new_library_path)
      field = java.lang.Class.for_name("java.lang.ClassLoader").get_declared_field("sys_paths")
      if field
        field.accessible = true
        field.set(java.lang.Class.for_name("java.lang.System").get_class_loader, nil)
      end
      return @@loaded_libraries[dir] = true
    end
    

    def self.has_slider(*args) #:nodoc:
      raise "has_slider has been replaced with a nicer control_panel library. Check it out."
    end
    

    # When you make a new sketch, you pass in (optionally), 
    # a width, height, title, and whether or not you want to 
    # run in full-screen. 
    #
    # This is a little different than Processing where height
    # and width are declared inside the setup method instead.
    def initialize(options={})
      super()
      $app = self
      proxy_java_fields
      set_sketch_path unless online?
      make_accessible_to_the_browser if online?
      @width  = options[:width]
      @height = options[:height]
      @title  = options[:title] || File.basename(Processing::SKETCH_PATH, '.rb').titleize
      @full_screen = options[:full_screen] || false
      self.init
      determine_how_to_display
    end


    # Provide a loggable string to represent this sketch.
    def inspect
      "#<Processing::App:#{self.class}:#{@title}>"
    end
    
    
    # By default, your sketch path is the folder that your sketch is in.
    # If you'd like to do something fancy, feel free.
    def set_sketch_path(path=nil)
      field = @declared_fields['sketchPath']
      local = SKETCH_ROOT
      default = $__windows_app_mode__ ? "#{local}/lib" : local
      field.set_value(java_self, path || default)
    end
    
    
    # Specify what rendering Processing should use, without needing to pass size.
    def render_mode(mode_const)
      @render_mode = mode_const
      size(@width || width, @height || height, @render_mode)
    end


    # There's just so many functions in Processing,
    # Here's a convenient way to look for them.
    def find_method(method_name)
      reg = Regexp.new("#{method_name}", true)
      self.methods.sort.select {|meth| reg.match(meth)}
    end


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
      (0..cols*rows).map do |i|
        x = col_size * (i % cols)
        y = row_size * i.div(cols)
        yield x, y
      end
    end
    
    
    # Provide a convenient handle for the Java-space version of self.
    def java_self
      @java_self ||= Java.ruby_to_java self
    end


    # Fix java conversion problems getting the last key
    # If it's ASCII, return the character, otherwise the integer
    def key
      int = @declared_fields['key'].value(java_self)
      int < 256 ? int.chr : int
    end


    # From ROP. Turns a color hash-string into hexadecimal, for Processing.
    def hex(value)
      value[1..-1].hex + 0xff000000
    end

    
    # Fields that should be made accessible as under_scored.
    def mouse_x;      mouseX;       end
    def mouse_y;      mouseY;       end
    def pmouse_x;     pmouseX;      end
    def pmouse_y;     pmouseY;      end
    def frame_count;  frameCount;   end
    def mouse_button; mouseButton;  end
    def key_code;     keyCode;      end


    # frame_rate needs to support reading and writing
    def frame_rate(fps = nil)
      return @declared_fields['frameRate'].value(java_self) unless fps
      super(fps)
    end
    
    
    # Is the sketch still displaying with the default size?
    def default_size?
      @declared_fields['defaultSize'].value(java_self)
    end
    
    
    # Is the sketch done displaying itself?
    def done_displaying?
      @done_displaying
    end
    

    # Is the mouse pressed for this frame?
    def mouse_pressed?
      Java.java_to_primitive(java_class.field("mousePressed").value(java_object))
    end


    # Is a key pressed for this frame?
    def key_pressed?
      Java.java_to_primitive(java_class.field("keyPressed").value(java_object))
    end
    
    
    # lerp_color takes three or four arguments, in Java that's two
    # different methods, one regular and one static, so:
    def lerp_color(*args)
      args.length > 3 ? self.class.lerp_color(*args) : super(*args) 
    end
    
    
    # Make a request to render full screen
    def full_screen
      @full_screen = true
    end


    # Cleanly close and shutter a running sketch.
    def close
      $app = nil
      control_panel.remove if respond_to?(:control_panel) && !online?
      container = online? ? JRUBY_APPLET : @frame
      container.remove(self)
      self.destroy
      container.dispose
    end
    
    
    private
    
    # Proxy over a list of Java declared fields that have the same name as 
    # some methods. Add to this list as needed.
    def proxy_java_fields
      @declared_fields = {}
      fields = %w(sketchPath key frameRate defaultSize)
      fields.each {|f| @declared_fields[f] = java_class.declared_field(f) }
    end
    
    
    # Tests to see which display method should run.
    def determine_how_to_display
      # Wait for init to get its grey tracksuit on and run a few laps.
      sleep 0.02 while default_size?
      
      if online?
        display_in_an_applet
      elsif @full_screen
        # linux doesn't support full screen exclusive mode, but don't worry, it works very well
        display   = java.awt.GraphicsEnvironment.get_local_graphics_environment.get_default_screen_device
        linux     = java.lang.System.get_property("os.name") == "Linux"
        supported = display.full_screen_supported?
        supported || linux ? display_full_screen(display) : display_in_a_window
      else
        display_in_a_window
      end
      @done_displaying = true
    end
    
    
    # Go full screen, if possible
    def display_full_screen(display)
      @frame = java.awt.Frame.new(display.default_configuration)
      mode = display.display_mode
      @width, @height = mode.get_width, mode.get_height
      @frame.set_undecorated true
      @frame.set_ignore_repaint true
      @frame.set_background java.awt.Color.black
      @frame.set_layout java.awt.BorderLayout.new
      @frame.add(self, java.awt.BorderLayout::CENTER)
      @frame.pack
      display.set_full_screen_window @frame
      @frame.set_location(0, 0)
      @frame.show
      self.request_focus
    end


    def display_in_a_window
      @frame = javax.swing.JFrame.new(@title)
      @frame.add(self)
      @frame.pack
      @frame.set_default_close_operation(javax.swing.JFrame::EXIT_ON_CLOSE)
      @frame.set_resizable(false)
      # Plus 22 for the height of the window's title bar
      @frame.set_size(@width || width, (@height || height) + 22)
      @frame.show
    end


    def display_in_an_applet
      JRUBY_APPLET.set_size(@width, @height)
      JRUBY_APPLET.background_color = nil
      JRUBY_APPLET.double_buffered = false
      JRUBY_APPLET.add self
      JRUBY_APPLET.validate
      # Add the callbacks to peacefully expire.
      JRUBY_APPLET.on_stop { self.stop }
      JRUBY_APPLET.on_destroy { self.destroy }
    end
    
    
    # When the net library is included, we make the Ruby interpreter
    # accessible to javascript as the 'ruby' variable. From javascript,
    # you can call evalScriptlet() to run code against the sketch.
    def make_accessible_to_the_browser
      return unless library_loaded?('net')
      field = java.lang.Class.for_name("org.jruby.JRubyApplet").get_declared_field("runtime")
      field.set_accessible true
      ruby = field.get(JRUBY_APPLET)
      window = Java::netscape.javascript.JSObject.get_window(JRUBY_APPLET)
      window.set_member('ruby', ruby)
    end

  end
end
