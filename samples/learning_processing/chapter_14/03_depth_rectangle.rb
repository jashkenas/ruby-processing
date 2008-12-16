require 'ruby-processing'

class DepthRectangleSketch < Processing::App

  def setup
    @z = 8
    size 400, 400, P3D
  end

  def draw
    background 255
    stroke 0
    fill 175
    # Translate to a point before displaying a shape there
    translate width/2, height/2, @z

    rectMode CENTER
    rect 0, 0, 8, 8

    # Increment z (i.e. move the shape toward the viewer)
    @z += 1

    # Start rectangle over
    @z = 0 if @z > 400 
  end

end

DepthRectangleSketch.new :title => "Depth Rectangle", :width => 400, :height => 400
