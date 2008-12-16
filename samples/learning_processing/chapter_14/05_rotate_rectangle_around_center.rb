require 'ruby-processing'

include Math

class RotateRectangleAroundCenterSketch < Processing::App

  def setup
    size 400, 400, P3D
  end

  def draw
    background 255
    stroke 0
    fill 175

    # translate to center
    translate width/2, height/2
    # The greek letter, theta, is often used as the name of a variable to store an angle
    # The angle ranges from 0 to PI, based on the ratio of mouseX location to the sketch's width.
    theta = PI * mouseX / width 

    rotate theta
    rectMode CENTER
    rect 0, 0, 200, 200
  end

end

RotateRectangleAroundCenterSketch.new :title => "Rotate Rectangle Around Center",  :width => 400,  :height => 400

