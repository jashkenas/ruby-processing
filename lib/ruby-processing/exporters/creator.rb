module Processing
  
  # This class creates blank sketches, with the boilerplate filled in.
  class Creator < BaseExporter
    
    # Create a blank sketch, given a path.
    def create!(path, args)
      usage path
      main_file = File.basename(path, ".rb")
      # Check to make sure that the main file exists
      already_exists = File.exists?(path) || File.exists?("#{File.dirname(path)}/#{main_file.underscore}.rb")
      if already_exists
        puts "That sketch already exists."
        exit
      end
      
      # Get the substitutions
      @name =       main_file.camelize
      @file_name =  main_file.underscore
      @title =      main_file.titleize
      @width =      args[0] || "500"
      @height =     args[1] || "500"
  
      # Make the file
      dir = File.dirname path
      mkdir_p dir
      template = File.new("#{RP5_ROOT}/lib/templates/create/blank_sketch.rb.erb")
      rendered = render_erb_from_string_with_binding(template.read, binding)
      full_path = File.join(dir, "#{@file_name}.rb")
      File.open(full_path, "w") {|f| f.print(rendered) }
      puts "Created Sketch \"#{@title}\" in #{full_path.sub(/\A\.\//, '')}"
    end
    
    # Show the help/usage message for create.
    def usage(predicate)
      unless predicate
        puts <<-USAGE
  
      Usage: script/generate <sketch_to_generate> <width> <height>
      Width and Height are optional.
      
      Example: script/generate fancy_drawing/app 800 600
  
      USAGE
        exit
      end
    end
  end
end