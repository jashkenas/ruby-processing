# This class is a thin wrapper around Processing's PApplet.
# Most of the code here is for interfacing with Swing, 
# web applets, going fullscreen and so on.

require 'java'

module Processing 

  # Conditionally load core.jar
  require "#{RP5_ROOT}/lib/core/core.jar" unless Object.const_defined?(:JRUBY_APPLET)  
  include_package "processing.core"

  # This is the main Ruby-Processing class, and is what you'll
  # inherit from when you create a sketch. This class can call
  # all of the methods available in Processing, and has two 
  # mandatory methods, 'setup' and 'draw', both of which you
  # should define in your sketch. 'setup' will be called one
  # time when the sketch is first loaded, and 'draw' will be 
  # called constantly, for every frame.
  class App < PApplet
    include Math

    include_class "javax.swing.JFrame"
    
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
     :sq, :constrain, :dist, :blend_color].each do |meth|
      method = <<-EOS
        def #{meth}(*args)
          self.class.#{meth}(*args)
        end
      EOS
      eval method
    end
    

    def self.current=(app); @current_app = app; end
    def self.current; @current_app; end   
    

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
    

    # For pure ruby libraries.
    # The library should have an initialization ruby file 
    # of the same name as the library folder.
    #
    # If a library is put into a 'library' folder next to the sketch it will
    # be used instead of the library that ships with Ruby-Processing.
    def self.load_ruby_library(dir)
      dir = dir.to_sym
      return true if @@loaded_libraries[dir]
      return @@loaded_libraries[dir] = (require "library/#{dir}/#{dir}") if online?
      local_path = "#{Dir.pwd}/library/#{dir}"
      gem_path = "#{RP5_ROOT}/library/#{dir}"
      path = File.exists?(local_path) ? local_path : gem_path
      return @@loaded_libraries[dir] = (require "#{path}/#{dir}")
    end


    # For pure java libraries, such as the ones that are available
    # on this page: http://processing.org/reference/libraries/index.html
    #
    # If a library is put into a 'library' folder next to the sketch it will
    # be used instead of the library that ships with Ruby-Processing.
    #
    # P.S. -- Loading libraries which include native code needs to 
    # hack the Java ClassLoader, so that you don't have to 
    # futz with your PATH. But it's probably bad juju.
    def self.load_java_library(dir)
      dir = dir.to_sym
      return true if @@loaded_libraries[dir]
      return @@loaded_libraries[dir] = !!(JRUBY_APPLET.get_parameter("archive").match(%r(#{dir}))) if online?
      local_path = "#{Dir.pwd}/library/#{dir}"
      gem_path = "#{RP5_ROOT}/library/#{dir}"
      path = File.exists?(local_path) ? local_path : gem_path
      jars = Dir.glob("#{path}/**/*.jar")
      raise LoadError if jars.length == 0
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


    # Used by the Processing::Watcher to completely remove all 
    # traces of the current sketch, so that it can be loaded afresh.
    def self.wipe_out_current_app!
      app = Processing::App.current
      return unless app
      app_class_name = app.class.to_s.to_sym
      app.close
      Object.send(:remove_const, app_class_name)
    end


    # When you make a new sketch, you pass in (optionally), 
    # a width, height, title, and whether or not you want to 
    # run in full-screen. 
    #
    # This is a little different than Processing where height
    # and width are declared inside the setup method instead.
    def initialize(options = {})
      super()
      $app = App.current = self
      set_sketch_path unless online?
      make_accessible_to_the_browser
      options = {
        :width => 400, 
        :height => 400, 
        :title => "",
        :full_screen => false
      }.merge(options)
      @width, @height, @title = options[:width], options[:height], options[:title]
      @render_mode = P2D
      determine_how_to_display options
    end


    # Provide a loggable string to represent this sketch.
    def inspect
      "#<Processing::App:#{self.class}:#{@title}>"
    end
    
    
    # By default, your sketch path is the folder that your sketch is in.
    # If you'd like to do something fancy, feel free.
    def set_sketch_path(path=nil)
      field = self.java_class.declared_field('sketchPath')
      field.set_value(Java.ruby_to_java(self), path || File.dirname(SKETCH_PATH))
    end


    # There's just so many functions in Processing,
    # Here's a convenient way to look for them.
    def find_method(method_name)
      reg = Regexp.new("#{method_name}", true)
      self.methods.sort.select {|meth| reg.match(meth)}
    end


    # Specify what rendering Processing should use.
    def render_mode(mode_const)
      @render_mode = mode_const
      size(@width, @height, @render_mode)
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


    # Fix java conversion problems getting the last key
    def key
      field = java_class.declared_field 'key'
      app = Java.ruby_to_java self
      field.value app
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


    # Is the mouse pressed for this frame?
    def mouse_pressed?
      Java.java_to_primitive(java_class.field("mousePressed").value(java_object))
    end


    # Is a key pressed for this frame?
    def key_pressed?
      Java.java_to_primitive(java_class.field("keyPressed").value(java_object))
    end
    

    # Cleanly close and shutter a running sketch.
    def close
      Processing::App.current = nil
      control_panel.remove if respond_to?(:control_panel) && !online?
      container = (@frame || JRUBY_APPLET)
      container.remove(self)
      self.destroy
      container.dispose
    end

    
    def quit
      exit
    end
    
    
    private
    
    # Tests to see which display method should run.
    def determine_how_to_display(options)
      if online? # Then display it in an applet.
        display_in_an_applet
      elsif options[:full_screen] # Then display it fullscreen.
        graphics_env = java.awt.GraphicsEnvironment.get_local_graphics_environment.get_default_screen_device
        graphics_env.is_full_screen_supported ? display_full_screen(graphics_env) : display_in_a_window
      else # Then display it in a window.
        display_in_a_window
      end
    end
    
    
    def display_full_screen(graphics_env)
      @frame = java.awt.Frame.new
      mode = graphics_env.display_mode
      @width, @height = mode.get_width, mode.get_height
      gc = graphics_env.get_default_configuration
      @frame.set_undecorated true
      @frame.set_background java.awt.Color.black
      @frame.set_layout java.awt.BorderLayout.new
      @frame.add(self, java.awt.BorderLayout::CENTER)
      @frame.pack
      graphics_env.set_full_screen_window @frame
      @frame.set_location(0, 0)
      @frame.show
      self.init
      self.request_focus
    end


    def display_in_a_window
      @frame = JFrame.new(@title)
      @frame.add(self)
      @frame.setSize(@width, @height + 22)
      @frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
      @frame.setResizable(false)
      @frame.show
      self.init
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
      self.init
    end
    
    
    # When the net library is included, we make the Ruby interpreter
    # accessible to javascript as the 'ruby' variable. From javascript,
    # you can call evalScriptlet() to run code against the sketch.
    def make_accessible_to_the_browser
      return unless library_loaded?('net') && online?
      field = java.lang.Class.for_name("org.jruby.JRubyApplet").get_declared_field("runtime")
      field.set_accessible true
      ruby = field.get(JRUBY_APPLET)
      window = Java::netscape.javascript.JSObject.get_window(JRUBY_APPLET)
      window.set_member('ruby', ruby)
    end

  end
end
