BASIC = <<-CODE
def setup
  size %s, %s
end

def draw

end
CODE

BASIC_MODE = <<-CODE
def setup
  size %s, %s, %s
end

def draw

end
CODE

CLASS_BASIC = <<-CODE
class %s
  def setup
    size %s, %s
  end
  
  def draw
  
  end
end
CODE

CLASS_MODE = <<-CODE
class %s
  def setup
    size %s, %s, %s
  end
  
  def draw
  
  end
end
CODE

INNER = <<-CODE
class %s
  include Processing::Proxy

end
CODE

module Processing
  # Write file to disk
  class SketchWriter
    def initialize(template, file_name)
      save(template, file_name)
    end

    private

    def save(template, file)
      File.open(file, 'w+') do |f|
        f.write(template)
      end
    end
  end

  # An abstract class providing common methods for real creators
  class Creator
    ALL_DIGITS = /\A\d+\Z/

    def already_exist(path)
      new_file = "#{File.dirname(path)}/#{path.underscore}.rb"
      return if !File.exist?(path) && !File.exist?(new_file)
      puts 'That file already exists!'
      exit
    end

    # Show the help/usage message for create.
    def usage
      puts <<-USAGE

      Usage: rp5 create <sketch_to_generate> <width> <height> <mode>
      mode can be P2D / P3D.
      Use    --wrap for a sketch wrapped as a class
      Use    --inner to generated a ruby version of 'java' Inner class
      Examples: rp5 create app 800 600
      rp5 create app 800 600 p3d --wrap
      rp5 create inner_class --inner

      USAGE
    end
  end

  # This class creates bare sketches, with an optional render mode
  class BasicSketch < Creator
    # Create a blank sketch, given a path.
    def basic_template
      format(BASIC, @width, @height)
    end

    def basic_template_mode
      format(BASIC_MODE, @width, @height, @mode)
    end

    def create!(path, args)
      return usage if /\?/ =~ path || /--help/ =~ path
      # Check to make sure that the main file doesn't exist already
      already_exist(path)
      @file_name = "#{File.dirname(path)}/#{path.underscore}.rb"
      @width = args[0]
      @height = args[1]
      @mode = args[2].upcase unless args[2].nil?
      template = @mode.nil? ? basic_template : basic_template_mode
      SketchWriter.new(template, @file_name)
    end
  end

  # This class creates class wrapped sketches, with an optional render mode
  class ClassSketch < Creator
    def class_template
      format(CLASS_BASIC, @name, @width, @height)
    end

    def class_template_mode
      format(CLASS_MODE, @name, @width, @height, @mode)
    end
    # Create a bare blank sketch, given a path.
    def create!(path, args)
      return usage if /\?/ =~ path || /--help/ =~ path
      main_file = File.basename(path, '.rb')
      # Check to make sure that the main file doesn't exist already
      already_exist(path)
      @name = main_file.camelize
      @file_name = "#{File.dirname(path)}/#{path.underscore}.rb"
      @title = main_file.titleize
      @width = args[0]
      @height = args[1]
      @mode = args[2].upcase unless args[2].nil?
      template = @mode.nil? ? class_template : class_template_mode
      SketchWriter.new(template, @file_name)
    end
  end

  # This class creates a ruby-processing class that mimics java inner class
  class Inner < Creator
    def inner_class_template
      format(INNER, @name)
    end
    # Create a blank sketch, given a path.
    def create!(path, _args_)
      return usage if /\?/ =~ path || /--help/ =~ path
      main_file = File.basename(path, '.rb')
      # Check to make sure that the main file doesn't exist already
      already_exist(path)
      @name = main_file.camelize
      @file_name = "#{File.dirname(path)}/#{path.underscore}.rb"
      SketchWriter.new(inner_class_template, @file_name)
    end
  end
end
