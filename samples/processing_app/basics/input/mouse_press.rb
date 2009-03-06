require 'ruby-processing'

# Move the mouse to position the shape. 
# Press the mouse button to invert the color. 

class MousePress < Processing::App

  def setup
    fill 126
    background 102
  end
  
  def draw
  	mouse_pressed? ? stroke(255) : stroke(0)
  	line mouse_x-66, mouse_y, mouse_x+66, mouse_y
  	line mouse_x, mouse_y-66, mouse_x, mouse_y+66
  end
  
end

MousePress.new :title => "Mouse Press", :width => 200, :height => 200