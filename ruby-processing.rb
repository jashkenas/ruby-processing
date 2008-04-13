# Inspired by John Weir's Dynamite
# Send suggestions, ideas, and hate-mail to jashkenas [at] gmail.com
# Also, send samples and libraries.
#
# This code is released into the public domain.
# http://creativecommons.org/licenses/publicdomain/
# Revision 0.6
# - omygawshkenas

require 'java'

module JavaLang
  include_package "java.lang"
end

module Processing 
  
  # Conditionally load core.jar
  begin
    include_class "processing.core.PApplet"
  rescue NameError
    require File.expand_path(File.dirname(__FILE__)) + "/core.jar"
  end
  
  include_package "processing.core"
  
  class App < PApplet
    
    include_class "javax.swing.JFrame"
    attr_accessor :frame
    alias_method :oval, :ellipse
    alias_method :stroke_width, :stroke_weight
    alias_method :rgb, :color
    alias_method :gray, :color
    
    METHODS_TO_WATCH_FOR = { :mouse_pressed => :mousePressed,
                             :mouse_dragged => :mouseDragged,
                             :mouse_clicked => :mouseClicked,
                             :mouse_moved   =>   :mouseMoved, 
                             :mouse_released => :mouseReleased,
                             :keyPressed    =>  :key_pressed,
                             :keyReleased   => :key_released }
                            
    def self.method_added(method_name)
      if METHODS_TO_WATCH_FOR.keys.include?(method_name)
        alias_method METHODS_TO_WATCH_FOR[method_name], method_name
      end
    end
    
    def self.current=(app); @current_app = app; end
    def self.current; @current_app; end
    
    # For pure ruby libs.
    # The library should have an initialization .rb 
    # of the same name as the library folder.
    def self.load_ruby_library(folder)
      if Object.const_defined?(:JRUBY_APPLET)
        require "#{folder}/#{folder}"
      else
        require "library/#{folder}/#{folder}"
      end
    end
    
    # Loading libraries which include native code needs to 
    # hack the Java ClassLoader, so that you don't have to 
    # futz with your PATH. But its probably bad juju.
    def self.load_java_library(folder)
      unless Object.const_defined?(:JRUBY_APPLET)
        base = "library#{File::SEPARATOR}#{folder}#{File::SEPARATOR}"
        jars = Dir.glob("#{base}*.jar")
        base2 = "#{base}library#{File::SEPARATOR}"
        jars = jars + Dir.glob("#{base2}*.jar")
        jars.each {|jar| require jar }
        raise "Could not load the #{folder} library. Make sure that it's installed." if jars.length == 0 
        # Here goes:
        sep = java.io.File.pathSeparator
        path = JavaLang::System.getProperty("java.library.path")
        new_path = base + sep + base + "library" + sep + path
        JavaLang::System.setProperty("java.library.path", new_path)
        field = java.lang.Class.for_name("java.lang.ClassLoader").get_declared_field("sys_paths")
        if field
          field.accessible = true
          field.set(java.lang.Class.for_name("java.lang.System").get_class_loader, nil)
        end
      end
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
    end
    
    def setup() end
    def draw() end
      
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
      JavaLang::System.exit(0)
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
    
end