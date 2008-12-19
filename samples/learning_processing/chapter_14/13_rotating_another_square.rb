require 'ruby-processing'

class RotatingAnotherSquareSketch < Processing::App

  def setup
    render_mode P3D
    rect_mode CENTER
    @theta2 = 0
  end

  def draw
    background 255
    stroke 0
    fill 175

    translate 150, 150
    rotate_y @theta2
    rect 0, 0, 60, 60
    @theta2 += 0.02
  end

end

RotatingAnotherSquareSketch.new :title => "Rotating Another Square",  :width => 200,  :height => 200

