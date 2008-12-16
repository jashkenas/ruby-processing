require 'ruby-processing'

include Math

class RotateAllSketch < Processing::App

  def setup
    size 400, 400, P3D
  end

  def draw
    background 255
    stroke 0
    fill 175

    translate width/2, height/2
    rotateX PI * mouseY / height
    rotateY PI * mouseX / height
    rectMode CENTER
    rect 0, 0, 200, 200
  end

end

RotateAllSketch.new :title => "Rotate All",  :width => 400,  :height => 400

