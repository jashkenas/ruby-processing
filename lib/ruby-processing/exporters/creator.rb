module Processing
  require 'erb'

  class SketchWriter
    include ERB::Util

    def initialize(template, param = {})
      @name = param[:name]
      @file_name = param[:file_name]
      @title = param[:title]
      @width = param[:width]
      @height = param[:height]
      @mode = param[:mode].upcase unless param[:mode].nil?
      @template = template
      save(@file_name)
    end

    def render
      ERB.new(@template).result(binding)
    end

    def save(file)
      File.open(file, 'w+') do |f|
        f.write(render)
      end
    end
  end

  # An abstract class providing common methods for real creators
  class Creator

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
%(
def setup
  size <%=@width%>, <%=@height%>
end

def draw

end
)
    end

    def basic_template_mode
%(
def setup
  size <%=@width%>, <%=@height%>, <%=@mode%>
end

def draw

end
)
    end

    def create!(path, args)
      return usage if /\?/ =~ path || /--help/ =~ path
      main_file = File.basename(path, '.rb')
      # Check to make sure that the main file doesn't exist already
      already_exist(path)
      @param = {
        name: main_file.camelize,
        file_name: "#{File.dirname(path)}/#{path.underscore}.rb",
        title: main_file.titleize,
        width: args[0],
        height: args[1],
        mode: args[2]
      }
      @with_size = @param[:width] && @param[:width].match(ALL_DIGITS) &&
        @param[:height] && @param[:height].match(ALL_DIGITS)
      template = @param[:mode].nil? ? basic_template : basic_template_mode
      SketchWriter.new(template, @param)
    end
  end

  # This class creates class wrapped sketches, with an optional render mode
  class ClassSketch < Creator

    def class_template
%(
class <%=@name%> < Processing::App
  def setup
    size <%=@width%>, <%=@height%>
  end

  def draw

  end
end

# <%=@name%>.new(x: 20, y: 20)
)
    end

    def class_template_mode
%(
class <%=@name%> < Processing::App
  def setup
    size <%=@width%>, <%=@height%>, <%=@mode%>
  end

  def draw

  end
end

# <%=@name%>.new(x: 20, y: 20)
)
    end
    # Create a bare blank sketch, given a path.
    def create!(path, args)
      return usage if /\?/ =~ path || /--help/ =~ path
      main_file = File.basename(path, '.rb')
      # Check to make sure that the main file doesn't exist already
      already_exist(path)
      @param = {
        name: main_file.camelize,
        file_name: "#{File.dirname(path)}/#{path.underscore}.rb",
        title: main_file.titleize,
        width: args[0],
        height: args[1],
        mode: args[2]
      }
      @with_size = @param[:width] && @param[:width].match(ALL_DIGITS) &&
        @param[:height] && @param[:height].match(ALL_DIGITS)
      template = @param[:mode].nil? ? class_template : class_template_mode
      SketchWriter.new(template, @param)
    end
  end

  # This class creates a ruby-processing class that mimics java inner class
  class Inner < Creator
    def inner_class_template
%(
class <%=@name%>
  include Processing::Proxy

end
)
    end
    # Create a blank sketch, given a path.
    def create!(path, _args_)
      return usage if /\?/ =~ path || /--help/ =~ path
      main_file = File.basename(path, '.rb')
      # Check to make sure that the main file doesn't exist already
      already_exist(path)
      @param = {
        name: main_file.camelize,
        file_name: "#{File.dirname(path)}/#{path.underscore}.rb",
        title: main_file.titleize
      }
      SketchWriter.new(inner_class_template, @param)
    end
  end
end
