require 'ruby-processing'

class RotatingOneSquareSketch < Processing::App

  def setup
    size 400, 400, P3D
    @theta = 0
  end

  def draw
    background 255
    stroke 0
    fill 175
    rectMode CENTER

    translate 100, 100
    rotateZ @theta
    rect 0, 0, 120, 120
    @theta += 0.02
  end

end

RotatingOneSquareSketch.new :title => "Rotating One Square",  :width => 400,  :height => 400

