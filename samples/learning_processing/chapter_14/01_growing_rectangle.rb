require 'ruby-processing'

class GrowingRectangleSketch < Processing::App

  def setup
    @r = 8
  end

  def draw
    background 255
    # Display a rectangle in the middle of the screen
    stroke 0
    fill 175
    rectMode CENTER
    rect width/2, height/2, @r, @r

    # Increase the rectangle size
    @r += 1

    # Start rectangle over
    @r = 0 if @r > width 
  end

end

GrowingRectangleSketch.new :title => "Growing Rectangle", :width => 400, :height => 400
