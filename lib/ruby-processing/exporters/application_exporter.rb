# This is a utility to export Ruby-Processing sketches as Applications.

module Processing
  class ApplicationExporter < BaseExporter
    
    def export!(sketch)
      # Check to make sure that the main file exists
      @main_file_path, @main_file, @main_folder = *get_main_file(sketch)
      usage( @main_file_path && File.exists?(@main_file_path) )
      
      # Extract all the cool details.
      @info = extract_information
      hash_to_ivars @info
      
      # Make the appropriate directory
      app_dir = "#{@title}.app"
      remove_entry_secure app_dir if File.exists?(app_dir)
      mkdir_p app_dir
      
      # Copy over all the required files
      prefix = "lib"
      cp_r(Dir["#{RP5_ROOT}/lib/templates/application/{*,**}"], app_dir)
      necessary_files = [@main_file_path]
      necessary_files += Dir["#{RP5_ROOT}/lib/{*,**}"]
      necessary_files += @real_requires
      necessary_files << "#{@main_folder}/data" if File.exists?("#{@main_folder}/data")
      necessary_files.uniq!
      cp_r(necessary_files, File.join(app_dir, prefix))
      cp_r(@libraries, File.join(app_dir, prefix, "library")) unless @libraries.empty?
      
      # Move the icon
      potential_icon = Dir.glob(File.join(app_dir, prefix, "data/*.icns"))[0]
      move(potential_icon, File.join(app_dir, "Contents/Resources/sketch.icns"), :force => true ) if potential_icon
      
      # Figure out the substitutions.
      file_list = Dir.glob(app_dir + "{/**/*.{rb,jar},/data/*.*}").map {|f| f.sub(app_dir + "/", "")}
      @class_path = file_list.map {|f| "$JAVAROOT/" + f.sub(prefix+"/", "") }.join(":")
      @linux_class_path = file_list.map{|f| f.sub(prefix+"/", "")}.join(":")
      @windows_class_path = file_list.map{|f| f.sub(prefix+"/", "")}.join(",")
      
      # Do it.
      render_erb_in_path_with_binding(app_dir, binding, :delete => true)
      rm Dir.glob(app_dir + "/**/*.{class,java}")
      runnable = app_dir + "/" + File.basename(@main_file, ".rb")
      move app_dir + "/run", runnable
      move app_dir + "/run.exe", runnable + ".exe"
      `chmod +x "#{runnable}"`
      cd app_dir + "/Contents/Resources"
      `ln -s ../../lib Java`
      
    end
    
    def usage(predicate)
      unless predicate
        puts <<-USAGE
        
      The application exporter will generate a Mac application for you.
      Usage: script/application <path_to_sketch>
      Example: script/applet samples/jwishy.rb 
      
      USAGE
        exit
      end
    end
  end
end