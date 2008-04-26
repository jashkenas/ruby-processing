require 'ruby-processing'

class KineticType < Processing::App
  load_java_library "opengl"

  WORDS = ["sometimes it's like", "the lines of text", "are so happy", "that they want to dance",
    "or leave the page or jump", "can you blame them?", "living on the page like that",
    "waiting to be read..."]

  include Math

  def setup
    render_mode OPENGL

    frame_rate 30

    # Array of line objects
    @lns = [];

    # Load the font from the sketch's data directory
    f = load_font(File.dirname(__FILE__) + "/Univers66.vlw.gz")
    text_font f, 1.0

    # White type, black background
    fill 255

    # Creating the line objects
    i = -1
    @lines = WORDS.map do |ln|
      i += 1
      Line.new self, ln, 0, i * 70, f
    end
  end

  def draw
    background 0

    translate (width / 2.0) - 350, (height / 2.0) - 240, -450
    rotateY 0.3

    # Now animate every line object & draw it...
    @lines.each_with_index do |line,i|
      f1 = sin((i + 1.0) * (millis() / 10000.0) * TWO_PI)
      f2 = sin((8.0 - i) * (millis() / 10000.0) * TWO_PI)
      push_matrix
      translate 0.0, line.ypos, 0.0
      0.upto(line.letters.length - 1) do |j|
        if j != 0
          translate(text_width(line.letters[j - 1].char)*75, 0.0, 0.0)
        end
        rotate_y(f1 * 0.035 * f2)
        push_matrix
        scale(75.0, 75.0, 75.0)
        text(line.letters[j].char, 0.0, 0.0)
        pop_matrix
      end
      pop_matrix
    end
  rescue => e
    puts e.to_s, *e.backtrace
    raise e
  end

  class AppObject
    attr_accessor :app
    def method_missing(meth, *args, &block)
      app.send(meth, *args, &block)
    end
  end

  class Line < AppObject
    attr_accessor :string, :xpos, :ypos, :highlight_num,
      :font, :speed, :curl_in_x, :letters

    def initialize(app, s, i, j, bagelfont)
      @app, @string, @xpos, @ypos, @font = app, s, i, j, bagelfont
      @letters = []
      f1 = 0.0
      s.each_byte do |c|
        f1 += text_width c
        @letters << Letter.new(c, f1, 0.0)
      end
      @curl_in_x = 0.1
    end
  end

  class Letter
    attr_accessor :char, :x, :y
    def initialize(c, x, y)
      @char, @x, @y = c, x, y
    end
  end
end

KineticType.new :width => 200, :height => 200