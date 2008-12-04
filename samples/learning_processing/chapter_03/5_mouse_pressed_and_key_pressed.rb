require 'ruby-processing'

# Click the mouse to draw a square. Hit the space bar to clear the window.
class MousePressedAndKeyPressed < Processing::App

  def setup
    background 255
  end
  
  def draw
    # Nothing happens in draw in this example!
  end
  
  # Whenever the mouse is clicked, the code inside mouse_pressed runs.
  def mouse_pressed
    stroke 0
    fill 175
    rect_mode CENTER
    rect mouse_x, mouse_y, 16, 16
  end
  
  # Whenever a key is pressed, the code inside key_pressed runs.
  def key_pressed
    background 255
  end
  
end

MousePressedAndKeyPressed.new :title => "Mouse Pressed And Key Pressed", :width => 200, :height => 200