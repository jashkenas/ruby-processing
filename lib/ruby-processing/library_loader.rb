module Processing
  class LibraryLoader
    attr_reader :sketchbook_library_path

    def initialize
      @sketchbook_library_path = File.join(find_sketchbook_path || "", "libraries")
      @loaded_libraries = Hash.new(false)
    end
      
    # Detect if a library has been loaded (for conditional loading)
    def library_loaded?(library_name)
      @loaded_libraries[library_name.to_sym]
    end

    # Load a list of Ruby or Java libraries (in that order)
    # Usage: load_libraries :opengl, :boids
    #
    # If a library is put into a 'library' folder next to the sketch it will
    # be used instead of the library that ships with Ruby-Processing.
    def load_libraries(*args)
      args.each do |lib|
        loaded = load_ruby_library(lib) || load_java_library(lib)
        raise LoadError.new( "no such file to load -- #{lib}") if !loaded
      end
    end
    alias :load_library :load_libraries

    # For pure ruby libraries.
    # The library should have an initialization ruby file
    # of the same name as the library folder.
    def load_ruby_library(library_name)
      library_name = library_name.to_sym
      return true if @loaded_libraries[library_name]
      path = get_library_paths(library_name, "rb").first
      return false unless path
      return @loaded_libraries[library_name] = (require path)
    end


    # For pure java libraries, such as the ones that are available
    # on this page: http://processing.org/reference/libraries/index.html
    #
    # P.S. -- Loading libraries which include native code needs to
    # hack the Java ClassLoader, so that you don't have to
    # futz with your PATH. But it's probably bad juju.
    def load_java_library(library_name)
      library_name = library_name.to_sym
      return true if @loaded_libraries[library_name]
      path = get_library_directory_path(library_name, "jar")
      jars = get_library_paths(library_name, "jar")
      return false if jars.empty?
      jars.each {|jar| require jar }

      platform_specific_library_paths = get_platform_specific_library_paths(path)
      platform_specific_library_paths = platform_specific_library_paths.select do |path|
        test(?d, path) && !Dir.glob(File.join(path, "*.{so,dll,jnilib}")).empty?
      end

      if !platform_specific_library_paths.empty?
        platform_specific_library_paths << java.lang.System.getProperty("java.library.path")
        new_library_path = platform_specific_library_paths.join(java.io.File.pathSeparator)

        java.lang.System.setProperty("java.library.path", new_library_path)

        field = java.lang.Class.for_name("java.lang.ClassLoader").get_declared_field("sys_paths")
        if field
          field.accessible = true
          field.set(java.lang.Class.for_name("java.lang.System").get_class_loader, nil)
        end
      end
      return @loaded_libraries[library_name] = true
    end

    def get_platform_specific_library_paths(basename)
      bits = "32"
      if java.lang.System.getProperty("sun.arch.data.model") == "64" || 
         java.lang.System.getProperty("java.vm.name").index("64")
        bits = "64"
      end

      match_string, platform = {"Mac" => "macosx", "Linux" => "linux", "Windows" => "windows" }.detect do |string, platform_|
        java.lang.System.getProperty("os.name").index(string)
      end
      platform ||= "other"
      [ platform, platform+bits ].collect { |p| File.join(basename, p) }
    end

    def get_library_paths(library_name, extension = nil)
      dir = get_library_directory_path(library_name, extension) 
      Dir.glob("#{dir}/*.{rb,jar}")
    end

    protected

    def get_library_directory_path(library_name, extension = nil)
      extensions = extension ? [extension] : %w{jar rb}
      extensions.each do |ext|
        [ "#{SKETCH_ROOT}/library/#{library_name}", 
          "#{RP5_ROOT}/library/#{library_name}/library", 
          "#{RP5_ROOT}/library/#{library_name}", 
          "#{@sketchbook_library_path}/#{library_name}/library",
          "#{@sketchbook_library_path}/#{library_name}" 
        ].each do |path| 
          if File.exists?(path) && !Dir.glob(path + "/*.#{ext}").empty?
            return path
          end
        end
      end
      nil
    end

    def find_sketchbook_path
      preferences_paths = []
      sketchbook_paths = []
      if sketchbook_path = CONFIG["sketchbook_path"]
        return File.expand_path(sketchbook_path)
      else
        ["'Application Data/Processing'", "AppData/Roaming/Processing", 
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
          sketchbook_path = matched_lines.first
        else
          sketchbook_path = sketchbook_paths.first
        end
        return sketchbook_path
      end
    end
    
  end
end
