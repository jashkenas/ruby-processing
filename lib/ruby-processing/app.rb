# version without embedded or online
# This class is a thin wrapper around Processing's PApplet.
# Most of the code here is for interfacing with Swing,
# web applets, going fullscreen and so on.

require 'java'
require 'ruby-processing/config'
require 'ruby-processing/helper_methods'
require 'ruby-processing/library_loader'

Dir["#{RP5_ROOT}/lib/core/\*.jar"].each { |jar| require jar }


# Include some processing classes that we'd like to use:
%w(PShape PImage PGraphics PFont PVector).each do |klass|
  java_import "processing.core.#{klass}"
end

%w(PGraphics2D PGraphics3D PShader PShapeOpenGL).each do |klass|
  java_import "processing.opengl.#{klass}"
end

%w(Event MouseEvent KeyEvent TouchEvent).each do |klass|
  java_import "processing.event.#{klass}"
end

module Processing
  include_package 'processing.core'
  include_package 'processing.opengl'
  include_package 'processing.event'
  
  # This is the main Ruby-Processing class, and is what you'll
  # inherit from when you create a sketch. This class can call
  # all of the methods available in Processing, and has two
  # mandatory methods, 'setup' and 'draw', both of which you
  # should define in your sketch. 'setup' will be called one
  # time when the sketch is first loaded, and 'draw' will be
  # called constantly, for every frame.
  class App < PApplet
    include Math
    include HelperMethods
    
    # Alias some methods for familiarity for Shoes coders.
    #attr_accessor :frame, :title
    alias_method :oval, :ellipse
    alias_method :stroke_width, :stroke_weight
    alias_method :rgb, :color
    alias_method :gray, :color
    
    
    # When certain special methods get added to the sketch, we need to let
    # Processing call them by their expected Java names.
    def self.method_added(method_name) #:nodoc:
      # Watch the definition of these methods, to make sure
      # that Processing is able to call them during events.
      methods_to_alias = {
        mouse_pressed:  :mousePressed,
        mouse_dragged:  :mouseDragged,
        mouse_clicked:  :mouseClicked,
        mouse_moved:    :mouseMoved,
        mouse_released: :mouseReleased,
        key_pressed:    :keyPressed,
        key_released:   :keyReleased,
        key_typed:      :keyTyped
      }
      if methods_to_alias.keys.include?(method_name)
        alias_method methods_to_alias[method_name], method_name
      end
    end
    
    
    # Class methods that we should make available in the instance.
    [:map, :pow, :norm, :lerp, :second, :minute, :hour, :day, :month, :year,
    :sq, :constrain, :dist, :blend_color, :degrees, :radians, :mag, :println,
    :hex, :min, :max, :abs, :binary, :ceil, :nf, :nfc, :nfp, :nfs,
    :norm, :round, :trim, :unbinary, :unhex ].each do |meth|
      method = <<-EOS
      def #{meth}(*args)
      self.class.#{meth}(*args)
      end
      EOS
      eval method
    end
    
    # Handy getters and setters on the class go here:
    def self.sketch_class;  @sketch_class;        end
      @@full_screen = false
    def self.full_screen;   @@full_screen = true; end
    def full_screen?;       @@full_screen;        end
      
      
    # Keep track of what inherits from the Processing::App, because we're going
    # to want to instantiate one.
    def self.inherited(subclass)
      super(subclass)
      @sketch_class = subclass
    end
    
    def self.has_slider(*args) #:nodoc:
      raise "has_slider has been replaced with a nicer control_panel library. Check it out."
    end
    
    @@library_loader = LibraryLoader.new
    class << self
      def load_libraries(*args)
        @@library_loader.load_library(*args)
      end
      alias :load_library :load_libraries 
      
      def library_loaded?(library_name)
        @@library_loader.library_loaded?(library_name)
      end
      
      def load_ruby_library(*args)
        @@library_loader.load_ruby_library(*args)
      end
      
      def load_java_library(*args)
        @@library_loader.load_java_library(*args)
      end
    end
    
    def library_loaded?(library_name)
      self.class.library_loaded?(library_name)
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
      set_sketch_path #unless Processing.online?
      mix_proxy_into_inner_classes
      #@started = false
      
      java.lang.Thread.default_uncaught_exception_handler = proc do |thread, exception|
        puts(exception.class.to_s)
        puts(exception.message)
        puts(exception.backtrace.collect { |trace| "\t" + trace })
        close        
      end
      
      # for the list of all available args, see 
      # http://processing.org/reference/

      args = []
      
      @width, @height = options[:width], options[:height]
      
      if @@full_screen || options[:full_screen] 
        @@full_screen = true
        args << "--present"
      end      
      @render_mode  ||= JAVA2D
        x = options[:x] || 0
        y = options[:y] || 0
        args << "--location=#{x},#{y}"
        
        title = options[:title] || File.basename(SKETCH_PATH).sub(/(\.rb|\.pde)$/, '').titleize
        args << title
        PApplet.run_sketch(args, self)
      #end
    end
    
    # def started?
      # @started
    # end
    # 
    # def hint(*args)
      # begin
        # super(*args)
      # rescue Exception => e
        # raise e.cause
      # end
    # end
    
    
    # Make sure we set the size if we set it before we start the animation thread.
    def start
      self.size(@width, @height) if @width && @height
      super()
    end
    
    # Provide a loggable string to represent this sketch.
    def inspect
      "#<Processing::App:#{self.class}:#{@title}>"
    end
   
    # Specify what rendering Processing should use, without needing to pass size.
#    def render_mode(mode_const)
#      @render_mode = mode_const
#      size(@width, @height, @render_mode)
#    end
    
    # Cleanly close and shutter a running sketch.
    def close
        control_panel.remove if respond_to?(:control_panel)
        self.dispose
        self.frame.dispose
    end
    
    
    private 
    
    # Mix the Processing::Proxy into any inner classes defined for the
    # sketch, attempting to mimic the behavior of Java's inner classes.
    def mix_proxy_into_inner_classes
      
      klass = Processing::App.sketch_class
      klass.constants.each do |name|
        const = klass.const_get name
        next if const.class != Class || const.to_s.match(/^Java::/)
        const.class_eval 'include Processing::Proxy'
      end
    end
    
  end # Processing::App
  
  
  # This module will get automatically mixed in to any inner class of
  # a Processing::App, in order to mimic Java's inner classes, which have
  # unfettered access to the methods defined in the surrounding class.
  module Proxy
    include Math
    
    # Generate the list of method names that we'd like to proxy for inner classes.
    # Nothing camelCased, nothing __internal__, just the Processing API.
    def self.desired_method_names(inner_class)
      bad_method = /__/    # Internal JRuby methods.
      unwanted = PApplet.superclass.instance_methods + Object.instance_methods
      unwanted -= ['width', 'height', 'cursor', 'create_image', 'background', 'size', 'resize']
      methods = Processing::App.public_instance_methods
      methods.reject {|m| unwanted.include?(m) || bad_method.match(m) || inner_class.method_defined?(m) }
    end
    
    
    # Proxy methods through to the sketch.
    def self.proxy_methods(inner_class)
      code = desired_method_names(inner_class).inject('') do |code, method|
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
      inner_class.class_eval(code)
    end
    
    
    # Proxy the sketch's constants on to the inner classes.
    def self.proxy_constants(inner_class)
      Processing::App.constants.each do |name|
        next if inner_class.const_defined?(name)
        inner_class.const_set(name, Processing::App.const_get(name))
      end
    end
    
    
    # Don't do all of the work unless we have an inner class that needs it.
    def self.included(inner_class)
      proxy_methods(inner_class)
      proxy_constants(inner_class)
    end
    
  end # Processing::Proxy
  
end # Processing
