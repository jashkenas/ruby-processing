require 'ruby-processing'

class GrowingRectangleSketch < Processing::App

  def setup
    rect_mode CENTER
    @r = 8
  end

  def draw
    background 255
    # Display a rectangle in the middle of the screen
    stroke 0
    fill 175
    rect width/2, height/2, @r, @r

    # Increase the rectangle size
    @r += 1

    # Start rectangle over
    @r = 0 if @r > width 
  end

end

GrowingRectangleSketch.new :title => "Growing Rectangle", :width => 200, :height => 200
