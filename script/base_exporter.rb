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
      info = {}
      source_code = info[:source_code] = File.open(@main_file_path, "r") {|file| file.readlines.join(" ")}
      info[:class_name] = source_code.match(/(\w+)\s*<\s*Processing::App/)
      info[:class_name] = (info[:class_name] ? info[:class_name][1] : nil)
      info[:title] = source_code.match(/#{info[:class_name]}\.new.*?:title\s=>\s["'](.+)["']/m)
      info[:width] = source_code.match(/#{info[:class_name]}\.new.*?:width\s=>\s(\d+)/m)
      info[:height] = source_code.match(/#{info[:class_name]}\.new.*?:height\s=>\s(\d+)/m)
      info[:description] = source_code.match(/# Description:(.*?)\n [^#]/m)
      matchdata = true
      info[:libs_to_load] = []
      code = source_code.dup
      while matchdata
        matchdata = code.match(/load_\w+_library.+?["':](\S+?)["'\s]/)
        if matchdata
          if File.exists?("library/#{matchdata[1]}")            
            @opengl = true if matchdata[1].match(/opengl/i)
            info[:libs_to_load] << matchdata[1]
          end
          code = matchdata.post_match
        end
      end
      defaults = {:description => "", :title => "Ruby-Processing Sketch", :width => "400", :height => "400"}
      defaults.each {|k,v| info[k] ? info[k] = info[k][1] : info[k] = v }
      return info
    end
    
    def hash_to_ivars(hash)
      hash.each{|k,v| instance_variable_set("@" + k.to_s, v) }
    end
    
    def render_erb_in_path_with_binding(path, some_binding, opts={})
      erbs = Dir.glob(path + "/**/*.erb")
      erbs.each do |erb|
        rendered = render_erb_from_string_with_binding(File.new(erb).read, some_binding)
        File.open(erb.sub(".erb", ""), "w") {|f| f.print rendered }
        rm erb if opts[:delete]
      end
    end
    
    def render_erb_from_string_with_binding(erb, some_binding)
      rendered = ERB.new(erb, nil, "<>", "rendered").result(some_binding)
    end
    
    # This method looks for all of the codes require or load 
    # directives, checks to see if the file exists (that it's 
    # not a gem, or a standard lib) and gives you the real ones.
    def discover_requires_that_actually_exist(main_file_path)
      code = File.open(main_file_path) {|f| f.readlines.join }
      code.gsub!("__FILE__", "'#{main_file_path}'")
      requirements = []
      matchdata = true
      while matchdata
        matchdata = code.match(/((require)|(load)) .*['"]/)
        if matchdata
          path = eval(matchdata[0].sub(/((require)|(load)) /, ""))
          requirements += Dir.glob(path + ".{rb,jar}")
          code = matchdata.post_match
        end
      end
      return requirements
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