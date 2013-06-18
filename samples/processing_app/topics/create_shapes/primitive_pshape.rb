#
# PrimitivePShape. 
# 
# Using a PShape to display a primitive shape (in this case, ellipse). 
#


# The PShape object
attr_reader :circle

def setup 
  size(640, 360, P2D)
  # Creating the PShape as an ellipse
  # The corner is -50,-50 so that the center is at 0,0 
  @circle = create_shape(ELLIPSE, -50, -25, 100, 50)
end

def draw
  background(51)
  # We can dynamically set the stroke and fill of the shape
  circle.set_stroke(color(255))  
  circle.set_stroke_weight(4)
  circle.set_fill(color(map(mouseX, 0, width, 0, 255)))
  # We can use translate to move the PShape
  translate(mouse_x, mouse_y)
  # Drawing the PShape
  shape(circle)
end

