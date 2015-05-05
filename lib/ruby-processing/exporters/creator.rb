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
class %s < Processing::App
  def setup
    size %s, %s
  end

  def draw

  end
end
CODE

CLASS_MODE = <<-CODE
class %s < Processing::App
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
  require_relative '../helpers/string_extra'
  require_relative '../helpers/camel_string'
  # Write file to disk
  class SketchWriter
    attr_reader :file
    def initialize(path)
      underscore = StringExtra.new(path).underscore
      @file = "#{File.dirname(path)}/#{underscore}.rb"
    end

    def save(template)
      File.open(file, 'w+') do |f|
        f.write(template)
      end
    end
  end

  # An abstract class providing common methods for real creators
  class Creator
    ALL_DIGITS = /\A\d+\Z/

    def already_exist(path)
      underscore = StringExtra.new(path).underscore
      new_file = "#{File.dirname(path)}/#{underscore}.rb"
      return if !FileTest.exist?(path) && !FileTest.exist?(new_file)
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
      main_file = File.basename(path, '.rb') # allow uneeded extension input
      writer = SketchWriter.new(main_file)
      @width = args[0]
      @height = args[1]
      @mode = args[2].upcase unless args[2].nil?
      template = @mode.nil? ? basic_template : basic_template_mode
      writer.save(template)
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
    # Create a class wrapped sketch, given a path.
    def create!(path, args)
      return usage if /\?/ =~ path || /--help/ =~ path
      main_file = File.basename(path, '.rb') # allow uneeded extension input
      # Check to make sure that the main file doesn't exist already
      already_exist(path)
      @name = CamelString.new(main_file).camelize
      writer = SketchWriter.new(main_file)
      @title = StringExtra.new(main_file).titleize
      @width, @height = args[0], args[1]
      @mode = args[2].upcase unless args[2].nil?
      template = @mode.nil? ? class_template : class_template_mode
      writer.save(template)
    end
  end

  # This class creates a pseudo 'java inner class' of the sketch
  class Inner < Creator
    def inner_class_template
      format(INNER, @name)
    end
    # Create a pseudo inner class, given a path.
    def create!(path, _args_)
      return usage if /\?/ =~ path || /--help/ =~ path
      main_file = File.basename(path, '.rb') # allow uneeded extension input
      # Check to make sure that the main file doesn't exist already
      already_exist(path)
      @name = main_file.camelize
      writer = SketchWriter.new(main_file)
      template = inner_class_template
      writer.save(template)
    end
  end
end
