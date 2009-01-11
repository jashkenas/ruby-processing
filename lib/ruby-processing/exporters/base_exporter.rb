# This base exporter implements some of the common 
# things needed to generate apps and applets.

require 'fileutils'
require 'erb'

module Processing
  class BaseExporter
    include FileUtils
    
    DEFAULT_TITLE = "Ruby-Processing Sketch"
    DEFAULT_DIMENSIONS = {'width' => '500', 'height' => '500'}
    DEFAULT_DESCRIPTION = ''
    
    def get_main_file(file)
      return file, File.basename(file), File.dirname(file)
    end
    
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
      @info
    end
    
    def extract_class_name(source)
      match = source.match(/(\w+)\s*<\s*Processing::App/)
      match ? match[1] : nil
    end
    
    def extract_title(source)
      match = source.match(/#{@info[:class_name]}\.new.*?:title\s=>\s["'](.+)["']/m)
      match ? match[1] : DEFAULT_TITLE
    end
    
    def extract_dimension(source, dimension)
      match = source.match(/#{@info[:class_name]}\.new.*?:#{dimension}\s=>\s(\d+)/m)
      match ? match[1] : DEFAULT_DIMENSIONS[dimension]
    end
    
    def extract_description(source)
      match = source.match(/# Description:(.*?)\n [^#]/m)
      match ? match[1] : DEFAULT_DESCRIPTION
    end
    
    def extract_libraries(source)
      libs = []
      code = source.dup
      loop do
        matchdata = code.match(/load_\w+_library.+?["':](\S+?)["'\s]/)
        break unless matchdata
        match = matchdata[1]
        @opengl = true if match.match(/opengl/i)
        local_path = "#{local_dir}/library/#{match}"
        rp5_path = "#{RP5_ROOT}/library/#{match}"
        File.exists?(local_path) ? libs << local_path : 
          (libs << rp5_path if File.exists?(rp5_path))
        code = matchdata.post_match
      end
      libs
    end
    
    # This method looks for all of the codes require or load 
    # directives, checks to see if the file exists (that it's 
    # not a gem, or a standard lib) and gives you the real ones.
    def extract_real_requires(source)
      code = source.dup
      requirements = []
      partial_paths = []
      loop do
        matchdata = code.match(/^.*\b(require|load)\b.*$/)
        break unless matchdata
        line = matchdata[0].gsub('__FILE__', "'#{@main_file_path}'")
        line = line.gsub(/\b(require|load)\b/, 'partial_paths << ')
        eval(line)
        requirements += Dir["{#{local_dir}/,}{#{partial_paths.join(',')}}.{rb,jar}"]
        code = matchdata.post_match
      end
      return requirements
    end
    
    def read_source_code
      File.read(@main_file_path)
    end
    
    def local_dir
      File.dirname(@main_file_path)
    end
    
    def hash_to_ivars(hash)
      hash.each{|k,v| instance_variable_set("@" + k.to_s, v) }
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