# This class is a thin wrapper around Processing's PApplet.
# Most of the code here is for interfacing with Swing,
# web applets, going fullscreen and so on.

require 'java'
require 'ruby-processing/helper_methods'

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
    include HelperMethods

    # Include some processing classes that we'd like to use:
    %w(PShape PImage PGraphics PFont PVector).each do |klass|
      import "processing.core.#{klass}"
    end

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
        :mouse_pressed  => :mousePressed,
        :mouse_dragged  => :mouseDragged,
        :mouse_clicked  => :mouseClicked,
        :mouse_moved    => :mouseMoved,
        :mouse_released => :mouseReleased,
        :key_pressed    => :keyPressed,
        :key_released   => :keyReleased,
        :key_typed      => :keyTyped
      }
      if methods_to_alias.keys.include?(method_name)
        alias_method methods_to_alias[method_name], method_name
      end
    end


    # Class methods that we should make available in the instance.
    [:map, :pow, :norm, :lerp, :second, :minute, :hour, :day, :month, :year,
     :sq, :constrain, :dist, :blend_color, :degrees, :radians, :mag, :println,
     :hex, :min, :max].each do |meth|
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


    # When you make a new sketch, you pass in (optionally),
    # a width, height, x, y, title, and whether or not you want to
    # run in full-screen.
    #
    # This is a little different than Processing where height
    # and width are declared inside the setup method instead.
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
    def self.load_java_library(library_name)
      library_name = library_name.to_sym
      return true if @@loaded_libraries[library_name]
      return @@loaded_libraries[library_name] = !!(JRUBY_APPLET.get_parameter("archive").match(%r(#{library_name}))) if Processing.online?
      local_path = "#{SKETCH_ROOT}/library/#{library_name}"
      gem_path = "#{RP5_ROOT}/library/#{library_name}"
      path = File.exists?(local_path) ? local_path : gem_path
      jars = Dir["#{path}/**/*.jar"]
      sketchbook_libraries_path = sketchbook_path + "/libraries"
      if File.exists?(sketchbook_libraries_path)
        jars.concat(Dir["#{sketchbook_libraries_path}/#{library_name}/library/*.jar"])
      end
      return false if jars.empty?
      jars.each {|jar| require jar }

      library_paths = [path, "#{path}/library"]
      library_paths.concat(platform_specific_library_paths.collect { |d| "#{path}/library/#{d}" } )
      library_paths.concat(platform_specific_library_paths.collect { |d| "#{sketchbook_libraries_path}/#{library_name}/library/#{d}" } )
      #p library_paths
      library_paths = library_paths.select do |path|
        test(?d, path) && !Dir.glob(File.join(path, "*.{so,dll,jnilib}")).empty?
      end

      #p library_paths
      library_paths << java.lang.System.getProperty("java.library.path")
      new_library_path = library_paths.join(java.io.File.pathSeparator)

      java.lang.System.setProperty("java.library.path", new_library_path)

      field = java.lang.Class.for_name("java.lang.ClassLoader").get_declared_field("sys_paths")
      if field
        field.accessible = true
        field.set(java.lang.Class.for_name("java.lang.System").get_class_loader, nil)
      end
      return @@loaded_libraries[library_name] = true
    end

    def self.sketchbook_path
      preferences_paths = []
      sketchbook_paths = []
      ["Application Data/Processing", "AppData/Roaming/Processing", 
       "Library/Processing", "Documents/Processing", 
       ".processing", "sketchbook"].each do |prefix|
        path = "#{ENV["HOME"]}/#{prefix}"
        pref_path = path+"/preferences.txt"
        if test(?f, pref_path)
          preferences_paths << pref_path
        end
        if test(?d, path)
          sketchbook_paths << path
        end
      end
      if !preferences_paths.empty?
        matched_lines = File.readlines(preferences_paths.first).grep(/^sketchbook\.path=(.+)/) { $1 }
        return matched_lines.first
      else
        sketchbook_paths.first
      end
    end

    def self.platform_specific_library_paths
      bits = "32"
      if java.lang.System.getProperty("sun.arch.data.model") == "64" || 
         java.lang.System.getProperty("java.vm.name").index("64")
        bits = "64"
      end

      match_string, platform = {"Mac" => "macosx", "Linux" => "linux", "Windows" => "windows" }.detect do |string, platform_|
        java.lang.System.getProperty("os.name").index(string)
      end
      platform ||= "other"
      [ platform, platform+bits ]
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
      mix_proxy_into_inner_classes

      java.lang.Thread.default_uncaught_exception_handler = proc do |thread, exception|
        puts(exception.message)
        puts(exception.backtrace.collect { |trace| "\t" + trace })
        close
      end

      # for the list of all available args, see 
      # http://processing.googlecode.com/svn/trunk/processing/build/javadoc/core/processing/core/PApplet.html#runSketch%28java.lang.String[],%20processing.core.PApplet%29
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
    end

    def hint(*args)
      begin
        super(*args)
      rescue Exception => e
        raise e.cause
      end
    end

    # Make sure we set the size if we set it before we start the animation thread.
    def start
      self.size(@width, @height) if @width && @height
      super()
    end

    # Provide a loggable string to represent this sketch.
    def inspect
      "#<Processing::App:#{self.class}:#{@title}>"
    end


    # We override size to support setting full_screen and to keep our
    # internal @width and @height in line.
    def size(*args)
      args[0], args[1] = screenWidth, screenHeight if @@full_screen && !args.empty?
      w, h, mode       = *args
      @width           = w     || @width
      @height          = h     || @height
      @render_mode     = mode  || @render_mode
      super(*args)
    rescue Exception => e
      raise e.cause
    end

    # Specify what rendering Processing should use, without needing to pass size.
    def render_mode(mode_const)
      @render_mode = mode_const
      size(@width, @height, @render_mode)
    end

    # Cleanly close and shutter a running sketch.
    def close
      #$app = nil
      if Processing.online?
        JRUBY_APPLET.remove(self)
      else
        control_panel.remove if respond_to?(:control_panel)
        self.dispose
        self.frame.dispose
      end
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

    def display_in_an_applet
      JRUBY_APPLET.background_color = nil
      JRUBY_APPLET.double_buffered = false
      JRUBY_APPLET.add self
      JRUBY_APPLET.validate
      # Add the callbacks to peacefully expire.
      JRUBY_APPLET.on_stop { self.stop }
      JRUBY_APPLET.on_destroy { self.destroy }
    end
  end # Processing::App


  # This module will get automatically mixed in to any inner class of
  # a Processing::App, in order to mimic Java's inner classes, which have
  # unfettered access to the methods defined in the surrounding class.
  module Proxy
    include Math

    # Generate the list of method names that we'd like to proxy for inner classes.
    # Nothing camelCased, nothing __internal__, just the Processing API.
    def self.desired_method_names
      bad_method = /__/    # Internal JRuby methods.
      unwanted = PApplet.superclass.instance_methods + Object.instance_methods
      unwanted -= ['width', 'height', 'cursor', 'create_image', 'background', 'size', 'resize']
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
