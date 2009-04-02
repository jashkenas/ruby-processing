# From the Processing Examples
# by Zach Lieberman
# Ruby version thanks to Nick Sieger
# Demonstrates method-proxying for inner classes.

class KineticType < Processing::App
  load_library :opengl

  WORDS = ["sometimes it's like", "the lines of text", "are so happy", "that they want to dance",
           "or leave the page or jump", "can you blame them?", "living on the page like that",
           "waiting to be read..."]

  def setup
    library_loaded?(:opengl) ? render_mode(OPENGL) : render_mode(P3D)
    frame_rate 30
    # Load the font from the sketch's data directory.
    text_font load_font("Univers66.vlw.gz"), 1.0
    fill 255

    # Creating the line objects
    @lines = Array.new(WORDS.length) do |i|
      Line.new(WORDS[i], 0, i*70)
    end
  end

  def draw
    background 0
    translate -240, -120, -450
    rotate_y 0.3
    # Now animate every line object & draw it...
    @lines.each_with_index do |line, i| 
      push_matrix
      translate 0.0, line.ypos, 0.0
      line.draw(i)
      pop_matrix
    end
  end
  
  
  class Line
    include Math
    attr_accessor :string, :xpos, :ypos, :letters
  
    def initialize(string, x, y)
      @string, @xpos, @ypos = string, x, y
      spacing = 0.0
      @letters = @string.split('').map do |c|
        spacing += text_width(c)
        Letter.new(c, spacing, 0.0)
      end
    end
    
    def compute_curve(line_num)
      base = millis / 10000.0 * PI * 2
      sin((line_num + 1.0) * base) * sin((8.0 - line_num) * base)
    end
    
    def draw(line_num)
      curve = compute_curve(line_num)
      @letters.each_with_index do |letter, i|
        translate(text_width(@letters[i-1].char)*75, 0.0, 0.0) if i > 0
        rotate_y(curve * 0.035)
        push_matrix
        scale(75.0, 75.0, 75.0)
        text(letter.char, 0.0, 0.0)
        pop_matrix
      end
    end
  end
  
  class Letter
    attr_accessor :char, :x, :y
    def initialize(c, x, y)
      @char, @x, @y = c, x, y
    end
  end
  
end

KineticType.new :width => 200, :height => 200, :title => "Kinetic Type"