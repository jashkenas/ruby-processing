# This class is a thin wrapper around Processing's PApplet.
# Most of the code here is for interfacing with Swing,
# web applets, going fullscreen and so on.

require 'java'

module Processing

  # Conditionally load core.jar
  require "#{RP5_ROOT}/lib/core/core.jar" unless Processing.online? || Processing.embedded?
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


    # When certain special methods get added to the sketch, we need to let
    # Processing call them by their expected Java names.
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
    def self.sketch_class;  @sketch_class;        end
    def self.full_screen;   @@full_screen = true; end
    def full_screen?;       @@full_screen;        end


    # Keep track of what inherits from the Processing::App, because we're going
    # to want to instantiate one.
    def self.inherited(subclass)
      super(subclass)
      @sketch_class = subclass
    end


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
      args.each do |lib|
        loaded = load_ruby_library(lib) || load_java_library(lib)
        raise LoadError.new "no such file to load -- #{lib}" if !loaded
      end
    end
    def self.load_library(*args); self.load_libraries(*args); end


    # For pure ruby libraries.
    # The library should have an initialization ruby file
    # of the same name as the library folder.
    def self.load_ruby_library(dir)
      dir = dir.to_sym
      return true if @@loaded_libraries[dir]
      if Processing.online?
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
      return @@loaded_libraries[dir] = !!(JRUBY_APPLET.get_parameter("archive").match(%r(#{dir}))) if Processing.online?
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
    # a width, height, x, y, title, and whether or not you want to
    # run in full-screen.
    #
    # This is a little different than Processing where height
    # and width are declared inside the setup method instead.
    def initialize(options={})
      super()
      $app = self
      proxy_java_fields
      set_sketch_path unless Processing.online?
      # make_accessible_to_the_browser if Processing.online?
      default_title = File.basename(SKETCH_PATH).sub(/(\.rb|\.pde)$/, '').titleize
      @width        = options[:width]
      @height       = options[:height]
      @frame_x      = options[:x]     || 0
      @frame_y      = options[:y]     || 0
      @title        = options[:title] ||  default_title
      @render_mode                    ||= JAVA2D
      @@full_screen                   ||= options[:full_screen]
      self.init
      determine_how_to_display
    end


    # Make sure we set the size if we set it before we start the animation thread.
    def start
      self.size(@width, @height) if @width && @height
      mix_proxy_into_inner_classes
      super()
    end


    # Provide a loggable string to represent this sketch.
    def inspect
      "#<Processing::App:#{self.class}:#{@title}>"
    end


    # By default, your sketch path is the folder that your sketch is in.
    # If you'd like to do something fancy, feel free.
    def set_sketch_path(path=nil)
      field = @declared_fields['sketchPath']
      field.set_value(java_self, path || SKETCH_ROOT)
    end


    # We override size to support setting full_screen and to keep our
    # internal @width and @height in line.
    def size(*args)
      args[0], args[1] = *full_screen_dimensions if @@full_screen && !args.empty?
      w, h, mode       = *args
      @width           = w     || @width
      @height          = h     || @height
      @render_mode     = mode  || @render_mode
      super(*args)
    end


    # Specify what rendering Processing should use, without needing to pass size.
    def render_mode(mode_const)
      @render_mode = mode_const
      size(@width, @height, @render_mode)
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
      (0...cols*rows).map do |i|
        x = col_size * (i % cols)
        y = row_size * i.div(cols)
        yield x, y
      end
    end

    # Shortcut for begin_shape/end_shape pair
    def shape(*mode)
      begin_shape *mode
      yield
      end_shape
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


    # Get the sketch path
    def sketch_path
      @declared_fields['sketchPath'].value(java_self)
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


    # Is the sketch still displaying with the default size?
    def default_size?
      @declared_fields['defaultSize'].value(java_self)
    end


    # Is the sketch finished?
    def finished?
      @declared_fields['finished'].value(java_self)
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


    # Cleanly close and shutter a running sketch.
    def close
      $app = nil
      if Processing.online?
        JRUBY_APPLET.remove(self)
        self.destroy
      else
        control_panel.remove if respond_to?(:control_panel)
        @frame.remove(self) if @frame
        self.destroy
        @frame.dispose if @frame
      end
    end


    private

    # Proxy over a list of Java declared fields that have the same name as
    # some methods. Add to this list as needed.
    def proxy_java_fields
      @declared_fields = {}
      fields = %w(sketchPath key frameRate defaultSize finished)
      fields.each {|f| @declared_fields[f] = java_class.declared_field(f) }
    end


    # Mix the Processing::Proxy into any inner classes defined for the
    # sketch, attempting to mimic the behavior of Java's inner classes.
    def mix_proxy_into_inner_classes
      unwanted = /Java::ProcessingCore/
      klass = Processing::App.sketch_class
      klass.constants.each do |name|
        const = klass.const_get name
        next if const.class != Class || const.to_s.match(unwanted)
        const.class_eval 'include Processing::Proxy'
      end
    end


    # Tests to see which display method should run.
    def determine_how_to_display
      # Wait for init to get its grey tracksuit on and run a few laps.
      sleep 0.02 while default_size? && !finished? && !@@full_screen

      if Processing.online?
        display_in_an_applet
      elsif full_screen?
        display   = java.awt.GraphicsEnvironment.local_graphics_environment.default_screen_device
        linux     = java.lang.System.get_property("os.name") == "Linux"
        supported = display.full_screen_supported? || linux
        supported ? display_full_screen(display) : display_in_a_window
      else
        display_in_a_window
      end
      @done_displaying = true
    end


    def display_full_screen(display)
      @frame = java.awt.Frame.new(display.default_configuration)
      mode = display.display_mode
      @width, @height = *full_screen_dimensions
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
      @frame.set_layout nil
      @frame.add self
      @frame.pack
      @frame.set_resizable false
      @frame.set_default_close_operation Processing.embedded? ?
        javax.swing.JFrame::DISPOSE_ON_CLOSE : javax.swing.JFrame::EXIT_ON_CLOSE
      ins          = @frame.get_insets
      hpad, vpad   = ins.left + ins.right, ins.top + ins.bottom
      frame_width  = [width, MIN_WINDOW_WIDTH].max + hpad
      frame_height = [height, MIN_WINDOW_HEIGHT].max + vpad
      @frame.set_size(frame_width, frame_height)
      set_bounds((frame_width - hpad - width) / 2.0, (frame_height - vpad - height) / 2.0, width, height)
      @frame.set_location(@frame_x, @frame_y)
      @frame.show
    end


    def display_in_an_applet
      JRUBY_APPLET.background_color = nil
      JRUBY_APPLET.double_buffered = false
      JRUBY_APPLET.add self
      JRUBY_APPLET.validate
      # Add the callbacks to peacefully expire.
      JRUBY_APPLET.on_stop { self.stop }
      JRUBY_APPLET.on_destroy { self.destroy }
    end


    # Grab the dimensions of the main display.
    # Some Linux variants don't have the 'display_mode'.
    def full_screen_dimensions
      screen = java.awt.GraphicsEnvironment.local_graphics_environment.default_screen_device.display_mode
      screen = java.awt.Toolkit.default_toolkit.screen_size if !display
      return screen.width, screen.height
    end


    # When the net library is included, we make the Ruby interpreter
    # accessible to javascript as the 'ruby' variable. From javascript,
    # you can call evalScriptlet() to run code against the sketch.
    #
    # def make_accessible_to_the_browser
    #   return unless library_loaded?('net')
    #   field = java.lang.Class.for_name("org.jruby.JRubyApplet").get_declared_field("runtime")
    #   field.set_accessible true
    #   ruby = field.get(JRUBY_APPLET)
    #   window = Java::netscape.javascript.JSObject.get_window(JRUBY_APPLET)
    #   window.set_member('ruby', ruby)
    # end

  end # Processing::App


  # This module will get automatically mixed in to any inner class of
  # a Processing::App, in order to mimic Java's inner classes, which have
  # unfettered access to the methods defined in the surrounding class.
  module Proxy

    # Generate the list of method names that we'd like to proxy for inner classes.
    # Nothing camelCased, nothing __internal__, just the Processing API.
    def self.desired_method_names
      bad_method = /__/    # Internal JRuby methods.
      unwanted = PApplet.superclass.instance_methods + Object.instance_methods
      unwanted -= ['width', 'height', 'cursor']
      methods = Processing::App.public_instance_methods
      methods.reject {|m| unwanted.include?(m) || bad_method.match(m) }
    end


    # Proxy methods through to the sketch.
    def self.proxy_methods
      code = desired_method_names.inject('') do |code, method|
        code << <<-EOS
          def #{method}(*args, &block)                # def rect(*args, &block)
            if block_given?                           #   if block_given?
              $app.send :'#{method}', *args, &block   #     $app.send(:rect, *args, &block)
            else                                      #   else
              $app.#{method} *args                    #     $app.rect *args
            end                                       #   end
          end                                         # end
        EOS
      end
      module_eval(code, "Processing::Proxy", 1)
    end


    # Proxy the sketch's constants on to the inner classes.
    def self.proxy_constants
      Processing::App.constants.each do |name|
        Processing::Proxy.const_set(name, Processing::App.const_get(name))
      end
    end


    # Don't do all of the work unless we have an inner class that needs it.
    def self.included(inner_class)
      return if @already_defined
      proxy_methods
      proxy_constants
      @already_defined = true
    end

  end # Processing::Proxy

end # Processing
