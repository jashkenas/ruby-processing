require 'ruby-processing'

class RotateXSketch < Processing::App

  def setup
    size 400, 400, P3D
    @theta = 0
  end

  def draw
    background 255
    stroke 0
    fill 175

    translate width/2, height/2
    rotateX @theta
    rectMode CENTER
    rect 0, 0, 200, 200
    @theta += 0.02
  end

end

RotateXSketch.new :title => "Rotate X",  :width => 400,  :height => 400
