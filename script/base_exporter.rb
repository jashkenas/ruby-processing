# This base exporter implements some of the common 
# things needed to generate apps and applets.

require 'fileutils'
require 'erb'

module Processing
  class BaseExporter
    include FileUtils
    
    def get_main_file
      return ARGV.first, File.basename(ARGV.first)
    end
    
    def extract_information
      # Extract information from main file
      source_code = File.open(@main_file_path, "r") {|file| file.readlines.join(" ")}
      class_name = source_code.match(/(\w+)\s*<\s*Processing::App/)[1]
      title = source_code.match(/#{class_name}\.new.*?:title\s=>\s["'](.+)["']/m)
      width = source_code.match(/#{class_name}\.new.*?:width\s=>\s(\d+)/m)
      height = source_code.match(/#{class_name}\.new.*?:height\s=>\s(\d+)/m)
      description = source_code.match(/# Description:(.*?)\n [^#]/m)
      matchdata = true
      libs_to_load = []
      code = source_code.dup
      while matchdata
        matchdata = code.match(/load_\w+_library.+?["':](\S+?)["'\s]/)
        if matchdata
          if File.exists?("library/#{matchdata[1]}")            
            @opengl = true if matchdata[1].match(/opengl/i)
            libs_to_load << matchdata[1]
          end
          code = matchdata.post_match
        end
      end
      return [source_code, class_name, title, width, height, description, libs_to_load]
    end
    
    def render_erb_in_path_with_binding(path, some_binding, opts={})
      erbs = Dir.glob(path + "/**/*.erb")
      erbs.each do |erb|
        rendered = ERB.new(File.new(erb).read, nil, "<>", "rendered").result(some_binding)
        File.open(erb.sub(".erb", ""), "w") {|f| f.print rendered }
        rm erb if opts[:delete]
      end
    end
    
    # Ripped from activesupport
    def titleize(word)
      humanize(underscore(word)).gsub(/\b([a-z])/) { $1.capitalize }
    end
    
    def humanize(lower_case_and_underscored_word)
      lower_case_and_underscored_word.to_s.gsub(/_id$/, "").gsub(/_/, " ").capitalize
    end
    
    def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
      if first_letter_in_uppercase
        lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
      else
        lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
      end
    end
  
    def underscore(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end
    
  end
end