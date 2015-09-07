# version without embedded or online
# This class is a thin wrapper around Processing's PApplet.
# Most of the code here is for interfacing with Swing,
# web applets, going fullscreen and so on.
require 'java'
require_relative 'helper_methods'
require_relative 'helpers/string_extra'
require_relative 'library_loader'
require_relative 'config'



module Processing
  # This is the main Ruby-Processing class, and is what you'll
  # inherit from when you create a sketch. This class can call
  # all of the methods available in Processing, and has two
  # mandatory methods, 'setup' and 'draw', both of which you
  # should define in your sketch. 'setup' will be called one
  # time when the sketch is first loaded, and 'draw' will be
  # called constantly, for every frame.
  Dir["#{RP_CONFIG["PROCESSING_ROOT"]}/core/library/\*.jar"].each do |jar| 
    require jar unless jar =~ /native/
  end
  Java::Monkstone::MathToolLibrary.load(JRuby.runtime)
  # Include some core processing classes that we'd like to use:
  include_package 'processing.core'

  # Watch the definition of these methods, to make sure
  # that Processing is able to call them during events.
  METHODS_TO_ALIAS ||= {
    mouse_pressed: :mousePressed,
    mouse_dragged: :mouseDragged,
    mouse_clicked: :mouseClicked,
    mouse_moved: :mouseMoved,
    mouse_released: :mouseReleased,
    key_pressed: :keyPressed,
    key_released: :keyReleased,
    key_typed: :keyTyped
  }
  # All sketches extend this class
  class App < PApplet
    include Math
    include HelperMethods
    include MathTool
    # Alias some methods for familiarity for Shoes coders.
    # attr_accessor :frame, :title
    alias_method :oval, :ellipse
    alias_method :stroke_width, :stroke_weight
    alias_method :rgb, :color
    alias_method :gray, :color

    def sketch_class
      self.class.sketch_class
    end

    # Keep track of what inherits from the Processing::App, because we're going
    # to want to instantiate one.
    def self.inherited(subclass)
      super(subclass)
      @sketch_class = subclass
    end

    class << self
      # Handy getters and setters on the class go here:
      attr_accessor :sketch_class, :library_loader

      def load_libraries(*args)
        library_loader ||= LibraryLoader.new
        library_loader.load_library(*args)
      end
      alias_method :load_library, :load_libraries

      def library_loaded?(library_name)
        library_loader.library_loaded?(library_name)
      end

      def load_ruby_library(*args)
        library_loader.load_ruby_library(*args)
      end

      def load_java_library(*args)
        library_loader.load_java_library(*args)
      end

      # When certain special methods get added to the sketch, we need to let
      # Processing call them by their expected Java names.
      def method_added(method_name) #:nodoc:
        return unless METHODS_TO_ALIAS.key?(method_name)
        alias_method METHODS_TO_ALIAS[method_name], method_name
      end
    end

    def library_loaded?(library_name)
      self.class.library_loaded?(library_name)
    end

    # It is 'NOT' usually necessary to directly pass options to a sketch, it
    # gets done automatically for you. Since processing-2.0 you should prefer
    # setting the sketch width and height and renderer using the size method,
    # in the sketch (as with vanilla processing), which should be the first
    # argument in setup. Sensible options to pass are x and y to locate sketch
    # on the screen, or full_screen: true (prefer new hash syntax)

    def initialize(options = {})
      super()
      post_initialize(options)
      $app = self
      proxy_java_fields
      set_sketch_path # unless Processing.online?
      mix_proxy_into_inner_classes
      java.lang.Thread.default_uncaught_exception_handler = proc do
        |_thread_, exception|
        puts(exception.class.to_s)
        puts(exception.message)
        puts(exception.backtrace.map { |trace| "\t#{trace}" })
        close
      end
      run_sketch(options)
    end

    def size(*args)
      w, h, mode       = *args
      @width           ||= w
      @height          ||= h
      @render_mode     ||= mode
      import_opengl if /opengl/ =~ mode
      super(*args)
    end

    def post_initialize(_args)
      nil
    end

    # Set the size if we set it before we start the animation thread.
    def start
      size(@width, @height) if @width && @height
      super()
    end

    # Provide a loggable string to represent this sketch.
    def inspect
      "#<Processing::App:#{self.class}:#{@title}>"
    end

    # Cleanly close and shutter a running sketch.
    def close
      control_panel.remove if respond_to?(:control_panel)
      dispose
      frame.dispose
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

    def import_opengl
      # Include processing opengl classes that we'd like to use:
      %w(FontTexture FrameBuffer LinePath LineStroker PGL
         PGraphics2D PGraphics3D PGraphicsOpenGL PShader
         PShapeOpenGL Texture).each do |klass|
        java_import "processing.opengl.#{klass}"
      end
    end

    def run_sketch(options = {})
      args = []
      @width, @height = options[:width], options[:height]
      if options[:full_screen]
        present = true
        args << '--full-screen'
        args << "--bgcolor=#{options[:bgcolor]}" if options[:bgcolor]
      end
      xc = Processing::RP_CONFIG['X_OFF'] ||= 0
      yc = Processing::RP_CONFIG['Y_OFF'] ||= 0
      x = options.fetch(:x, xc)
      y = options.fetch(:y, yc)
      args << "--location=#{x},#{y}"  # important no spaces here
      string_extra = StringExtra.new(File.basename(SKETCH_PATH).sub(/(\.rb)$/, ''))
      title = options.fetch(:title, string_extra.titleize)
      args << title
      PApplet.run_sketch(args.to_java(:string), self)
    end
  end # Processing::App

  # This module will get automatically mixed in to any inner class of
  # a Processing::App, in order to mimic Java's inner classes, which have
  # unfettered access to the methods defined in the surrounding class.
  module Proxy
    include Math
    include MathTool
    # Generate a list of method names to proxy for inner classes.
    # Nothing camelCased, nothing __internal__, just the Processing API.
    def self.desired_method_names(inner_class)
      bad_method = /__/    # Internal JRuby methods.
      unwanted = PApplet.superclass.instance_methods + Object.instance_methods
      unwanted -= %w(width height cursor create_image background size resize)
      methods = Processing::App.public_instance_methods
      methods.reject do |m|
        unwanted.include?(m) || bad_method.match(m) || inner_class.method_defined?(m)
      end
    end

    # Proxy methods through to the sketch.
    def self.proxy_methods(inner_class)
      code = desired_method_names(inner_class).reduce('') do |rcode, method|
        rcode << <<-EOS
        def #{method}(*args, &block)           # def rect(*args, &block)
        if block_given?                        #   if block_given?
        $app.send :'#{method}', *args, &block  #   ...
        else                                   #   else
        $app.#{method} *args                   #     $app.rect *args
        end                                    #   end
        end                                    # end
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
