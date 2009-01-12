module Processing
  
  # A utility class to export Ruby-Processing sketches as applets 
  # that can be viewed online.
  class AppletExporter < BaseExporter
    
    def export!(sketch)
      # Check to make sure that the main file exists
      @main_file_path, @main_file, @main_folder = *get_main_file(sketch)
      unless @main_file_path && File.exists?(@main_file_path)
        puts <<-USAGE
        
      The applet generator will generate a web-ready applet for you.
      Usage: script/applet <path_to_sketch>
      Example: script/applet samples/jwishy.rb 
      
      USAGE
        exit
      end
      
      # Extract all the cool details.
      @info = extract_information
      hash_to_ivars @info
      
      # Make the appropriate directory
      applet_dir = "#{@main_file.sub(".rb", "")}"
      remove_entry_secure applet_dir if File.exists?(applet_dir)
      mkdir_p applet_dir
      
      # Copy over all the required files
      necessary_files = [@main_file_path]
      necessary_files += Dir["#{RP5_ROOT}/lib/{*,**}"]
      necessary_files += @real_requires
      necessary_files << "#{@main_folder}/data" if File.exists?("#{@main_folder}/data")
      necessary_files += Dir["#{RP5_ROOT}/lib/templates/applet/{*,**}"]
      necessary_files += Dir.glob("library/{#{@libraries.join(",")}}") unless @libraries.empty?
      necessary_files.uniq!
      cp_r(necessary_files, applet_dir)
      cp_r(@libraries, File.join(applet_dir, "library")) unless @libraries.empty?
      
      # Figure out OpenGL replacements, if necessary:
      @starting_class = @opengl ? "com.sun.opengl.util.JOGLAppletLauncher" : "org.jruby.JRubyApplet"
      if @opengl
        opengl_files = Dir["#{applet_dir}/library/opengl/*.jar"]
        opengl_files += Dir["#{applet_dir}/library/opengl/library/*.jar"]
        move(opengl_files, applet_dir)
        opengl_dir = "#{applet_dir}/library/opengl"
        remove_entry_secure(opengl_dir) if File.exists?(opengl_dir)
        necessary_files.map! {|file| file.match(/^opengl/) ? File.basename(file) : file }
      end
      
      # Figure out the substitutions to make.
      file_list = Dir.glob(applet_dir + "{/**/*.{rb,jar},/data/*.*}").map {|f| f.sub(applet_dir+"/","")}
      h1 = "<h1>#{@title}</h1>"
      @description = "<div id='description'>#{h1}<p>#{@description.gsub!(/\n(\s*)?#/, "")}</p></div>" unless @description.empty?
      @width_plus_14 = (@width.to_i + 14).to_s
      @file_list = file_list.join(",")
      
      # Fill in the blanks in the HTML.    
      render_erb_in_path_with_binding(applet_dir, binding, :delete => true)
    end
  end
end