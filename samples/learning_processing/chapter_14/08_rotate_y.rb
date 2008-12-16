require 'ruby-processing'

class RotateYSketch < Processing::App

  def setup
    render_mode P3D
    rect_mode CENTER
    @theta = 0
  end

  def draw
    background 255
    stroke 0
    fill 175

    translate width/2, height/2
    rotate_y @theta
    rect 0, 0, 100, 100
    @theta += 0.02
  end

end

RotateYSketch.new :title => "Rotate Y", :width => 200, :height => 200
