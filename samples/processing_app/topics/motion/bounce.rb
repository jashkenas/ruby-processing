#
# Bounce. 
# 
# When the shape hits the edge of the window, it reverses its direction. 
#

RAD = 60       # Width of the shape
X_SPEED = 2.8  # Speed of the shape
Y_SPEED = 2.2  # Speed of the shape

attr_reader :xpos, :ypos, :xdirection, :ydirection

def setup 
  size(640, 360)
  no_stroke
  frame_rate(30)
  ellipse_mode(RADIUS)
  # Set the starting position of the shape
  @xpos = width/2
  @ypos = height/2
  @xdirection = 1  # Left or Right
  @ydirection = 1  # Top to Bottom
end

def draw 
  background(102)  
  # Update the position of the shape
  @xpos = xpos + ( X_SPEED * xdirection )
  @ypos = ypos + ( Y_SPEED * ydirection )  
  # Test to see if the shape exceeds the boundaries of the screen
  # If it does, reverse its direction by multiplying by -1
  if (xpos > width-RAD || xpos < RAD)
    @xdirection *= -1
  end
  if (ypos > height - RAD || ypos < RAD)
    @ydirection *= -1
  end  
  # Draw the shape
  ellipse(xpos, ypos, RAD, RAD)
end
