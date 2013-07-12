require 'fileutils'
require 'erb'
require 'ruby-processing/library_loader'

module Processing
  
  # This base exporter implements some of the common 
  # code-munging needed to generate apps and applets.
  class BaseExporter
    include FileUtils
    ## hashes with strings as keys need to retain old hash syntax
    DEFAULT_DIMENSIONS = {'width' => '100', 'height' => '100'}
    DEFAULT_DESCRIPTION = ''
    NECESSARY_FOLDERS = ['data', 'lib', 'vendor']
    
    # Returns the filepath, basename, and directory name of the sketch.
    def get_main_file(file)
      @file = file
      return file, File.basename(file), File.dirname(file)
    end
    
    # Centralized method to read the source of the sketch and extract
    # all the juicy details.
    def extract_information
      # Extract information from main file
      @info = {}
      @info[:source_code]     = source = read_source_code
      @info[:class_name]      = extract_class_name(source)
      @info[:title]           = extract_title(source)
      @info[:width]           = extract_dimension(source, 'width')
      @info[:height]          = extract_dimension(source, 'height')
      @info[:description]     = extract_description(source)
      @info[:libraries]       = extract_libraries(source)
      @info[:real_requires]   = extract_real_requires(source)
      hash_to_ivars @info
      @info
    end
    
    # Searches the source for a class name.
    def extract_class_name(source)
      match = source.match(/(\w+)\s*<\s*Processing::App/)
      match ? match[1] : 'Sketch'
    end
    
    # Searches the source for a title.
    def extract_title(source)
      match = source.match(/#{@info[:class_name]}\.new.*?:title\s=>\s["'](.+?)["']/m)
      match ? match[1] : File.basename(@file, '.rb').titleize
    end
    
    # Searches the source for the width and height of the sketch.
    def extract_dimension(source, dimension)
      match = source.match(/#{@info[:class_name]}\.new.*?:#{dimension}\s?=>\s?(\d+)/m)
      size_match = source.match(/^[^#]*size\(?\s*(\d+)\s*,\s*(\d+)\s*\)?/)
      return match[1] if match
      return (dimension == 'width' ? size_match[1] : size_match[2]) if size_match
      warn "using default dimensions for export, please use constants integer values in size() call instead of computed ones"
      DEFAULT_DIMENSIONS[dimension]
    end
    
    # Searches the source for a description of the sketch.
    def extract_description(source)
      match = source.match(/\A((\s*#(.*?)\n)+)[^#]/m)
      match ? match[1].gsub(/\s*#\s*/, "\n") : DEFAULT_DESCRIPTION
    end
    
    # Searches the source for any libraries that have been loaded.
    def extract_libraries(source)
      lines = source.split("\n")
      libs = lines.grep(/^[^#]*load_(?:java_|ruby_)?librar(?:y|ies)\s+(.+)/) do
        $1.split(/\s*,\s*/).collect do |raw_library_name| 
          raw_library_name.tr("\"':\r\n", '') 
        end
      end.flatten
      lib_loader = LibraryLoader.new
      libs.map { |lib| lib_loader.get_library_paths(lib) }.flatten.compact
    end
    
    # Looks for all of the codes require or load commands, checks 
    # to see if the file exists (that it's not a gem, or a standard lib) 
    # and hands you back all the real ones.
    def extract_real_requires(source)
      code = source.dup
      requirements = []
      partial_paths = []
      loop do
        matchdata = code.match(/^.*[^::\.\w](require_relative|require|load)\b.*$/)
        break unless matchdata
        line = matchdata[0].gsub('__FILE__', "'#{@main_file_path}'")
        line = line.gsub(/\b(require_relative|require|load)\b/, 'partial_paths << ')
        eval(line)
        where = "{#{local_dir}/,}{#{partial_paths.join(',')}}"
        unless line =~ /\.[^.]+$/
          where += ".{rb,jar}"
        end
        requirements += Dir[where]
        code = matchdata.post_match
      end
      requirements
    end
    
    
    protected
    
    def read_source_code
      File.read(@main_file_path)
    end
    
    def local_dir
      File.dirname(@main_file_path)
    end
    
    def hash_to_ivars(hash)
      hash.each{|k,v| instance_variable_set("@" + k.to_s, v) }
    end
    
    def wipe_and_recreate_destination
      remove_entry_secure @dest if File.exists?(@dest)
      mkdir_p @dest
    end
    
    def render_erb_in_path_with_binding(path, some_binding, opts={})
      erbs = Dir.glob(path + "/**/*.erb")
      erbs.each do |erb|
        string = File.open(erb) {|f| f.read }
        rendered = render_erb_from_string_with_binding(string, some_binding)
        File.open(erb.sub(".erb", ""), "w") {|f| f.print rendered }
        rm erb if opts[:delete]
      end
    end
    
    def render_erb_from_string_with_binding(erb, some_binding)
      rendered = ERB.new(erb, nil, "<>", "rendered").result(some_binding)
    end
    
  end
end
