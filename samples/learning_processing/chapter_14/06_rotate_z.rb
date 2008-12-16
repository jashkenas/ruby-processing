require 'ruby-processing'

class RotateZSketch < Processing::App

  def setup
    rect_mode CENTER
    render_mode P3D
    @theta = 0
  end

  def draw
    background 255
    stroke 0
    fill 175

    translate width/2, height/2
    rotateZ @theta
    rect 0, 0, 100, 100
    @theta += 0.02
  end

end

RotateZSketch.new :title => "Rotate Z",  :width => 200,  :height => 200
