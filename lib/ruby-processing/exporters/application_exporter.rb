module Processing
  
  # A utility class to export Ruby-Processing sketches as 
  # Mac/Win/Nix Applications.
  class ApplicationExporter < BaseExporter
    
    USAGE = <<-EOS
        
    The application exporter will generate a Mac application for you.
    Usage: script/application <path_to_sketch>
    Example: script/applet samples/jwishy.rb 
      
    EOS
    
    def export!(sketch)
      # Check to make sure that the main file exists
      @main_file_path, @main_file, @main_folder = *get_main_file(sketch)
      usage( @main_file_path && File.exists?(@main_file_path) )
      
      extract_information
      
      compute_destination_name
      
      wipe_and_recreate_destination
      
      copy_over_necessary_files
      
      calculate_substitutions
      
      create_executables
      
      symlink_library_into_place
    end
    
    def compute_destination_name
      @dest = "#{@title}.app"
    end
    
    def copy_over_necessary_files
      @prefix = "lib"
      cp_r(Dir["#{RP5_ROOT}/lib/templates/application/{*,**}"], @dest)
      @necessary_files = [@main_file_path]
      @necessary_files += Dir["#{RP5_ROOT}/lib/{*,**}"]
      @necessary_files += @real_requires
      NECESSARY_FOLDERS.each do |folder| 
        resource_path = File.join(@main_folder, folder)
        @necessary_files << resource_path if File.exists?(resource_path)
      end
      @necessary_files.uniq!
      cp_r(@necessary_files, File.join(@dest, @prefix))
      cp_r(@libraries, File.join(@dest, @prefix, "library")) unless @libraries.empty?
      # Then move the icon
      potential_icon = Dir.glob(File.join(@dest, @prefix, "data/*.icns"))[0]
      move(potential_icon, File.join(@dest, "Contents/Resources/sketch.icns"), :force => true ) if potential_icon
    end
    
    def calculate_substitutions
      file_list = ['lib/core/jruby-complete.jar']
      @class_path = file_list.map {|f| "$JAVAROOT/" + f.sub(@prefix+"/", "") }.join(":")
      @linux_class_path = file_list.map{|f| f.sub(@prefix+"/", "")}.join(":")
      @windows_class_path = file_list.map{|f| f.sub(@prefix+"/", "")}.join(",")
    end
    
    def create_executables
      render_erb_in_path_with_binding(@dest, binding, :delete => true)
      rm Dir.glob(@dest + "/**/*.java")
      runnable = @dest + "/" + File.basename(@main_file, ".rb")
      move @dest + "/run", runnable
      move @dest + "/run.exe", "#{runnable}.exe"
      chmod 0755, runnable
      chmod 0755, "#{runnable}.exe"
      chmod 0755, File.join(@dest, 'Contents', 'MacOS', 'JavaApplicationStub')
    end
    
    def symlink_library_into_place
      cd @dest + "/Contents/Resources"
      # Poor ol' windows can't symlink.
      # TODO...
      win = RUBY_PLATFORM.match(/mswin/i) || (RUBY_PLATFORM == 'java' && ENV_JAVA['os.name'].match(/windows/i))
      puts "\n[warning] Applications exported from Windows won't run on Macs...\n" if win 
      ln_s('../../lib', 'Java') unless win
    end
    
    def usage(predicate)
      return if predicate
      puts USAGE
      exit
    end
    
  end
end