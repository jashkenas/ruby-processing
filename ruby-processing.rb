# Ruby-Processing is for Code Art.
# Send suggestions, ideas, and hate-mail to jashkenas [at] gmail.com
# Also, send samples and libraries.
#
# Revision 0.8
# - omygawshkenas

require 'java'

module Processing 
  
  # Conditionally load core.jar
  require File.expand_path(File.dirname(__FILE__)) + "/core.jar" unless Object.const_defined?(:JRUBY_APPLET)  
  include_package "processing.core"
  
  class App < PApplet
    
    include_class "javax.swing.JFrame"
    include_class "javax.swing.JSlider"
    @@has_sliders = false
    include_class "javax.swing.JPanel"
    include_class "javax.swing.JLabel"
    
    attr_accessor :frame, :title
    alias_method :oval, :ellipse
    alias_method :stroke_width, :stroke_weight
    alias_method :rgb, :color
    alias_method :gray, :color
    
    METHODS_TO_WATCH_FOR = { :mouse_pressed => :mousePressed,
                             :mouse_dragged => :mouseDragged,
                             :mouse_clicked => :mouseClicked,
                             :mouse_moved   =>   :mouseMoved, 
                             :mouse_released => :mouseReleased,
                             :key_pressed => :keyPressed,
                             :key_released => :keyReleased }
                            
    def self.method_added(method_name)
      if METHODS_TO_WATCH_FOR.keys.include?(method_name)
        alias_method METHODS_TO_WATCH_FOR[method_name], method_name
      end
    end
    
    def self.current=(app); @current_app = app; end
    def self.current; @current_app; end
    
    # Detect if a library has been loaded (for conditional loading)
    @@loaded_libraries = Hash.new(false)
    def self.library_loaded?(folder)
      @@loaded_libraries[folder.to_sym]
    end
    def library_loaded?(folder); self.class.library_loaded?(folder); end
    
    # For pure ruby libs.
    # The library should have an initialization ruby file 
    # of the same name as the library folder.
    def self.load_ruby_library(folder)
      unless @@loaded_libraries[folder.to_sym]
        Object.const_defined?(:JRUBY_APPLET) ? prefix = "" : prefix = "library/"
        @@loaded_libraries[folder.to_sym] = require "#{prefix}#{folder}/#{folder}"
      end
      return @@loaded_libraries[folder.to_sym]
    end
    
    # Loading libraries which include native code needs to 
    # hack the Java ClassLoader, so that you don't have to 
    # futz with your PATH. But its probably bad juju.
    def self.load_java_library(folder)
      # Applets preload all the java libraries.
      unless @@loaded_libraries[folder.to_sym]
        if Object.const_defined?(:JRUBY_APPLET)
          @@loaded_libraries[folder.to_sym] = true if JRUBY_APPLET.get_parameter("archive").match(%r(#{folder}))
        else
          base = "library#{File::SEPARATOR}#{folder}#{File::SEPARATOR}"
          jars = Dir.glob("#{base}*.jar")
          base2 = "#{base}library#{File::SEPARATOR}"
          jars = jars + Dir.glob("#{base2}*.jar")
          jars.each {|jar| require jar }
          return false if jars.length == 0
          # Here goes...
          sep = java.io.File.pathSeparator
          path = java.lang.System.getProperty("java.library.path")
          new_path = base + sep + base + "library" + sep + path
          java.lang.System.setProperty("java.library.path", new_path)
          field = java.lang.Class.for_name("java.lang.ClassLoader").get_declared_field("sys_paths")
          if field
            field.accessible = true
            field.set(java.lang.Class.for_name("java.lang.System").get_class_loader, nil)
          end
          @@loaded_libraries[folder.to_sym] = true
        end
      end
      return @@loaded_libraries[folder.to_sym]
    end
    
    # Creates a slider, in a new window, to control an instance variable.
    # Sliders take a name and a range (optionally), returning an integer.
    def self.has_slider(name, range=0..100)
      return if Object.const_defined?(:JRUBY_APPLET)
      @@has_sliders = true
      @@slider_frame ||= JFrame.new
      @@slider_frame.instance_eval do
        def sliders; @sliders ||= []; end
        def listeners; @listeners ||= []; end
      end
      @@slider_panel ||= JPanel.new(java.awt.FlowLayout.new)
      attr_accessor name
      slider = JSlider.new((range.begin * 100), (range.end * 100))
      listener = SliderListener.new(slider, name.to_s + "=")
      slider.add_change_listener listener
      @@slider_frame.listeners << listener
      slider.set_minor_tick_spacing 1000
      slider.set_paint_ticks true
      label = JLabel.new(name.to_s)
      @@slider_panel.add label
      @@slider_panel.add slider
      @@slider_frame.sliders << {:name => name, :slider => slider}
    end
    
    def initialize(options = {})
      super()
      App.current = self
      options = {:width => 400, 
                :height => 400, 
                :title => "",
                :full_screen => false}.merge(options)
      @width, @height, @title = options[:width], options[:height], options[:title]
      display options
      display_slider_frame
    end
    
    def setup() end
    def draw() end
      
    def display_slider_frame
      if @@has_sliders
        @@slider_frame.add @@slider_panel
        @@slider_frame.set_size 200, 26 + (65 * @@slider_frame.sliders.size)
        @@slider_frame.setDefaultCloseOperation(JFrame::DISPOSE_ON_CLOSE)
        @@slider_frame.set_resizable false
        @@slider_frame.set_location(@width + 10, 0)
        @@slider_frame.show
        @@slider_frame.sliders.each {|s| s[:slider].set_value(self.send(s[:name]).to_i)}
        @@slider_frame.listeners.each {|l| l.stateChanged(nil)}
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
      @frame.setDefaultCloseOperation(JFrame::DISPOSE_ON_CLOSE)
      @frame.setResizable(false)
      @frame.show
      self.init
    end
    
    def display_in_an_applet
      JRUBY_APPLET.setSize(@width, @height)
      JRUBY_APPLET.background_color = nil
      JRUBY_APPLET.double_buffered = false
      JRUBY_APPLET.add self
      JRUBY_APPLET.validate
      # Add the callbacks to peacefully expire.
      JRUBY_APPLET.on_stop { self.stop }
      JRUBY_APPLET.on_destroy { self.destroy }
      self.init
    end
    
    # Tests to see if it's possible to go full screen.
    def display(options)
      if Object.const_defined?(:JRUBY_APPLET) # Then display it in an applet.
        display_in_an_applet
      elsif options[:full_screen] # Then display it fullscreen.
        graphics_env = java.awt.GraphicsEnvironment.get_local_graphics_environment.get_default_screen_device
        graphics_env.is_full_screen_supported ? display_full_screen(graphics_env) : display_in_a_window
      else # Then display it in a window.
        display_in_a_window
      end
    end
    
    # There's just so many methods in Processing,
    # Here's a convenient way to look for them.
    def find_method(method_name)
      reg = Regexp.new("#{method_name}", true)
      self.methods.sort.select {|meth| reg.match(meth)}
    end
    
    def close
      @frame.dispose
    end
    
    def quit
      java.lang.System.exit(0)
    end
    
    # Specify what rendering Processing should use.
    def render_mode(mode_const)
      size(@width, @height, mode_const)
    end
    
    def mouse_x
      mouseX
    end
    
    def mouse_y
      mouseY
    end
    
  end
  
  class SliderListener
    include javax.swing.event.ChangeListener
    
    def initialize(slider, callback)
      @slider, @callback = slider, callback
    end
    
    def stateChanged(state)
      Processing::App.current.send(@callback, @slider.get_value / 100.0)
    end
  end
    
end