require 'ruby-processing'

class RotatingOneSquareSketch < Processing::App

  def setup
    render_mode P3D
    rect_mode CENTER
    @theta1 = 0
  end

  def draw
    background 255
    stroke 0
    fill 175

    translate 50, 50
    rotateZ @theta1
    rect 0, 0, 60, 60
    @theta1 += 0.02
  end

end

RotatingOneSquareSketch.new :title => "Rotating One Square",  :width => 200,  :height => 200

