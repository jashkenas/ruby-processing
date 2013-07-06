# Move the mouse to position the shape. 
# Press the mouse button to invert the color. 


def setup
  size 640, 360
  fill 126
  background 102
end

def draw
  mouse_pressed? ? stroke(255) : stroke(0)
  line mouse_x - 66, mouse_y, mouse_x + 66, mouse_y
  line mouse_x, mouse_y - 66, mouse_x, mouse_y + 66
end
