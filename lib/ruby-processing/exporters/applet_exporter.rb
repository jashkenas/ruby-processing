module Processing
  
  # A utility class to export Ruby-Processing sketches as applets 
  # that can be viewed online.
  class AppletExporter < BaseExporter
    
    USAGE = <<-EOS
    
    The applet generator will generate a web-ready applet for you.
    Usage: script/applet <path_to_sketch>
    Example: script/applet samples/jwishy.rb
    
    EOS
    
    def export!(sketch)
      # Check to make sure that the main file exists
      @main_file_path, @main_file, @main_folder = *get_main_file(sketch)
      usage(@main_file_path && File.exists?(@main_file_path))
      
      extract_information
      
      compute_destination_name
            
      wipe_and_recreate_destination
      
      copy_over_necessary_files
      
      process_opengl_replacements
      
      calculate_substitutions
      
      render_erb_in_path_with_binding(@dest, binding, :delete => true)
    end
    
    def compute_destination_name
      @dest = "#{@main_file.sub(".rb", "")}"
    end
    
    def copy_over_necessary_files
      @necessary_files = [@main_file_path]
      @necessary_files += Dir["#{RP5_ROOT}/lib/{*,**}"]
      @necessary_files += @real_requires
      NECESSARY_FOLDERS.each do |folder| 
        resource_path = File.join(@main_folder, folder)
        @necessary_files << resource_path if File.exists?(resource_path)
      end
      @necessary_files += Dir["#{RP5_ROOT}/lib/templates/applet/{*,**}"]
      @necessary_files += Dir.glob("library/{#{@libraries.join(",")}}") unless @libraries.empty?
      @necessary_files.uniq!
      cp_r(@necessary_files, @dest)
      cp_r(@libraries, File.join(@dest, "library")) unless @libraries.empty?
    end
    
    def process_opengl_replacements
      @starting_class = @opengl ? "com.sun.opengl.util.JOGLAppletLauncher" : "org.jruby.JRubyApplet"
      return unless @opengl
      opengl_files = Dir["#{@dest}/library/opengl/*.jar"]
      opengl_files += Dir["#{@dest}/library/opengl/library/*.jar"]
      move(opengl_files, @dest)
      opengl_dir = "#{@dest}/library/opengl"
      remove_entry_secure(opengl_dir) if File.exists?(opengl_dir)
      @necessary_files.map! {|file| file.match(/^opengl/) ? File.basename(file) : file }
    end
    
    def calculate_substitutions
      file_list = Dir.glob(@dest + "{/**/*.{rb,jar},/data/*.*}").map {|f| f.sub(@dest+"/","")}
      @width = @width.to_i
      @file_list = file_list.join(",")
    end
    
    def usage(predicate)
      return if predicate
      puts USAGE
      exit
    end
    
  end
end