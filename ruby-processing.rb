# Ruby-Processing is for Code Art.
# Send suggestions, ideas, and hate-mail to jashkenas [at] gmail.com
# Also, send samples and libraries.
#
# This class is a thin wrapper around Processing's PApplet.
# Most of the code here is for interfacing with Swing, 
# web applets, going fullscreen, and drawing sliders.
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
    include_class "javax.swing.JPanel"
    include_class "javax.swing.JLabel"
    
    # Alias some methods for familiarity for Shoes coders.
    attr_accessor :frame, :title
    alias_method :oval, :ellipse
    alias_method :stroke_width, :stroke_weight
    alias_method :rgb, :color
    alias_method :gray, :color
    
    # Watch the definition of these methods, to make sure 
    # that Processing is able to call them during events.
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
    def self.slider_frame; @slider_frame; end
    
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
      unless @@loaded_libraries[folder.to_sym]
        if Object.const_defined?(:JRUBY_APPLET) # Applets preload all the java libraries.
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
      min, max = range.begin * 100, range.end * 100
      attr_accessor name
      initialize_slider_frame unless @slider_frame
      slider = Slider.new(min, max)
      slider.add_change_listener do
        val = slider.get_value / 100.0
        slider.update_label(val)
        Processing::App.current.send(name.to_s + "=", val)
      end
      slider.set_minor_tick_spacing((max - min).abs / 10) 
      slider.set_paint_ticks true
      slider.paint_labels = true
      label = JLabel.new("<html><br>" + name.to_s + "</html>")
      slider.label = label
      slider.name = name
      @slider_frame.sliders << slider
      @slider_frame.panel.add label
      @slider_frame.panel.add slider
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
      display_slider_frame if self.class.slider_frame
    end
    
    def setup() end
    def draw() end
      
    def display_slider_frame
      f = self.class.slider_frame
      f.add f.panel
      f.set_size 200, 32 + (71 * f.sliders.size)
      f.setDefaultCloseOperation(JFrame::DISPOSE_ON_CLOSE)
      f.set_resizable false
      f.set_location(@width + 10, 0)
      f.show
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
    
    # Tests to see which display method should run.
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
    
    # There's just so many functions in Processing,
    # Here's a convenient way to look for them.
    def find_method(method_name)
      reg = Regexp.new("#{method_name}", true)
      self.methods.sort.select {|meth| reg.match(meth)}
    end
    
    # Specify what rendering Processing should use.
    def render_mode(mode_const)
      size(@width, @height, mode_const)
    end
    
    def mouse_x; mouseX; end
    def mouse_y; mouseY; end
    def pmouse_x; pmouseX; end
    def pmouse_y; pmouseY; end
    
    def close
      @frame.dispose
    end
    
    def quit
      java.lang.System.exit(0)
    end
    
    
    private
    
    def self.initialize_slider_frame
      @slider_frame ||= JFrame.new
      class << @slider_frame
        attr_accessor :sliders, :panel
      end
      @slider_frame.sliders ||= []
      slider_panel ||= JPanel.new(java.awt.FlowLayout.new(1, 0, 0))
      @slider_frame.panel = slider_panel
    end
    
  end
  
  class Slider < javax.swing.JSlider
    attr_accessor :name, :label
    
    def initialize(*args)
      super(*args)
    end
    
    def update_label(value)
      value = value.to_s
      value << "0" if value.length < 4
      label.set_text "<html><br>#{@name.to_s}: #{value}</html>"
    end
  end
    
end