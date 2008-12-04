require 'ruby-processing'

class DrawingAContinuousLine < Processing::App

  def setup
    background 255
    smooth
  end
  
  def draw
    stroke 0
    # Draw a line from the previous mouse location to the current location.
    line pmouse_x, pmouse_y, mouse_x, mouse_y
  end
  
end

DrawingAContinuousLine.new :title => "Drawing A Continuous Line", :width => 200, :height => 200