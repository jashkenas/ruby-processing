#
# Continuous Lines. 
# 
# Click and drag the mouse to draw a line. 
#

def setup
  size(640, 360)
  background(102)
end

def draw
  stroke(255)
  if mouse_pressed?
    line(mouse_x, mouse_y, pmouse_x, pmouse_y)
  end
end
