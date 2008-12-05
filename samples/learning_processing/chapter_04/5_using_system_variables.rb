require 'ruby-processing'

class UsingSystemVariables < Processing::App

  def setup
    smooth
  end
  
  def draw
    background 100
    stroke 255
    
    # frame_count is used to color a rectangle
    fill(frame_count / 2)
    rect_mode CENTER
    
    # The rectangle will always be in the middle of the window
    # if it is located at (width/2, height/2)
    rect(width/2, height/2, mouse_x + 10, mouse_y + 10)
  end
  
  def key_pressed
    puts key
  end
  
end

UsingSystemVariables.new :title => "Using System Variables", :width => 200, :height => 200