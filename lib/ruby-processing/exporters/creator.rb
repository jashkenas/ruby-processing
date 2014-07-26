module Processing
  require_relative '../../ruby-processing/exporters/base_exporter'
  # This class creates blank sketches, with the boilerplate filled in.
  class Creator < BaseExporter

    ALL_DIGITS = /\A\d+\Z/

    # Create a blank sketch, given a path.
    # @TODO reduce cyclomatic complexity
    def create!(path, args, p3d)
      usage if /\?/ =~ path || /--help/ =~ path
      main_file = File.basename(path, '.rb')
      # Check to make sure that the main file doesn't exist already
      already_exists(path)

      # Get the substitutions
      @name           = main_file.camelize
      @file_name      = main_file.underscore
      @title          = main_file.titleize

      @width, @height = args[0], args[1]
      @with_size      = @width && @width.match(ALL_DIGITS) &&
                        @height && @height.match(ALL_DIGITS)

      # Make the file
      dir = File.dirname path
      mkdir_p dir
      template_name = p3d ? 'p3d_sketch.rb.erb' : 'blank_sketch.rb.erb'
      template = File.new("#{RP5_ROOT}/lib/templates/create/#{template_name}")
      rendered = render_erb_from_string_with_binding(template.read, binding)
      full_path = File.join(dir, "#{@file_name}.rb")
      File.open(full_path, 'w') { |f| f.print(rendered) }
      puts "Created a new Sketch in #{full_path.sub(/\A\.\//, '')}"
    end

    def already_exist(path)
      if File.exist?(path) || File.exist?("#{File.dirname(path)}/#{main_file.underscore}.rb")
        puts 'That sketch already exists.'
      end
      exit
    end

    # Show the help/usage message for create.
    def usage
      puts <<-USAGE

      Usage: script/generate <sketch_to_generate> <width> <height>
      Width and Height are optional.

      Example: script/generate fancy_drawing/app 800 600

      USAGE
      exit
    end
  end
end
