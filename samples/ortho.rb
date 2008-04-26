require 'ruby-processing'

class Ortho < Processing::App
  load_java_library "opengl"

  def setup
    render_mode OPENGL
    no_stroke
  end

  def draw
    background 255
    lights

    # ortho(0, width, 0, height, -10, 10)  # Default ortho settings
    ortho -width, mouseX, -height/2.0, mouseY/2.0, -10, 10

    translate 0, 0, -100
    rotateX Math::PI / 4
    rotateZ Math::PI / 3

    push_matrix
    0.upto(width - 1) do |i|
      0.upto(height - 1) do |j|
        box 10, 10, (j+i) / 4.0
        translate 20, 0, 0
      end
      translate -200, 20, 0
    end
    pop_matrix
  end
end

Ortho.new :width => 200, :height => 200 #(:full_screen => true)
