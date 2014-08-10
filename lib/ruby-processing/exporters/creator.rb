module Processing
  require_relative '../../ruby-processing/exporters/base_exporter'
  Param = Struct.new(:name, :file_name, :title, :width, :height, :mode)
  # An abstract class providing common methods for real creators
  class Creator < BaseExporter

    ALL_DIGITS = /\A\d+\Z/

    def already_exist(path)
      new_file = "#{File.dirname(path)}/#{path.underscore}.rb"
      if !File.exist?(path) && !File.exist?(new_file)
        return
      else
        puts 'That file already exists!'
        exit
      end
    end

    # Show the help/usage message for create.
    def usage
      puts <<-USAGE

      Usage: rp5 create <sketch_to_generate> <width> <height> <mode>
      mode can be P2D / P3D.
      Use    --wrap for a sketch wrapped as a class
      Use    --inner to generated a ruby version of 'java' Inner class
      Examples: rp5 create fancy_drawing/app 800 600
      rp5 create fancy_drawing/app 800 600 P3D --wrap
      rp5 create inner_class --inner

      USAGE
    end

    def create_file(path, param, rendered, type)
      # Make the file
      dir = File.dirname path
      mkdir_p dir
      ful_path = File.join(dir, "#{param.file_name}.rb")
      File.open(ful_path, 'w') { |f| f.print(rendered) }
      puts "Created #{type} \"#{param.title}\" in #{ful_path.sub(/\A\.\//, '')}"
    end
  end

  # This class creates bare sketches, with an optional render mode
  class BasicSketch < Creator
    # Create a blank sketch, given a path.
    def create!(path, args)
      return usage if /\?/ =~ path || /--help/ =~ path
      main_file = File.basename(path, '.rb')
      # Check to make sure that the main file doesn't exist already
      already_exist(path)
      @param = Param.new(
        main_file.camelize,
        main_file.underscore,
        main_file.titleize,
        args[0],
        args[1],
        args[2]
        )
      @with_size = @param.width && @param.width.match(ALL_DIGITS) &&
        @param.height && @param.height.match(ALL_DIGITS)
      template_name = @param.mode.nil? ? 'basic.rb.erb' : 'basic_mode.rb.erb'
      template = File.new("#{RP5_ROOT}/lib/templates/create/#{template_name}")
      rendered = render_erb_from_string_with_binding(template.read, binding)
      create_file(path, @param, rendered, 'Sketch')
    end
  end

  # This class creates class wrapped sketches, with an optional render mode
  class ClassSketch < Creator
    # Create a bare blank sketch, given a path.
    def create!(path, args)
      return usage if /\?/ =~ path || /--help/ =~ path
      main_file = File.basename(path, '.rb')
      # Check to make sure that the main file doesn't exist already
      already_exist(path)
      @param = Param.new(
        main_file.camelize,
        main_file.underscore,
        main_file.titleize,
        args[0],
        args[1],
        args[2]
        )
      @with_size = @param.width && @param.width.match(ALL_DIGITS) &&
        @param.height && @param.height.match(ALL_DIGITS)
      t_name = @param.mode.nil? ? 'basic_wrap.rb.erb' : 'mode_wrap.rb.erb'
      template = File.new("#{RP5_ROOT}/lib/templates/create/#{t_name}")
      rendered = render_erb_from_string_with_binding(template.read, binding)
      create_file(path, @param, rendered, 'Sketch')
    end
  end

  # This class creates a ruby-processing class that mimics java inner class
  class Inner < Creator
    # Create a blank sketch, given a path.
    def create!(path, _args_)
      return usage if /\?/ =~ path || /--help/ =~ path
      main_file = File.basename(path, '.rb')
      # Check to make sure that the main file doesn't exist already
      already_exist(path)
      @param = Param.new(
        main_file.camelize,
        main_file.underscore,
        main_file.titleize
        )
      template_name = 'inner_class.rb.erb'
      template = File.new("#{RP5_ROOT}/lib/templates/create/#{template_name}")
      rendered = render_erb_from_string_with_binding(template.read, binding)
      create_file(path, @param, rendered, "\"Inner Class\"")
    end
  end
end
