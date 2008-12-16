require 'ruby-processing'

class RotatingAnotherSquareSketch < Processing::App

  def setup
    size 400, 400, P3D
    @theta2 = 0
  end

  def draw
    background 255
    stroke 0
    fill 175
    rectMode CENTER

    translate 300, 300
    rotateY @theta2
    rect 0, 0, 120, 120
    @theta2 += 0.02
  end

end

RotatingAnotherSquareSketch.new :title => "Rotating Another Square",  :width => 400,  :height => 400

