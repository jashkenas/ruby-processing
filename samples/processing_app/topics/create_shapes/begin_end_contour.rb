#
# BeginEnd_contour
# 
# How to cut a shape out of another using begin_contour() and end_contour()
#
 
attr_reader :s

def setup
  size(640, 360, P2D)
  smooth
  # Make a shape
  @s = create_shape
  s.begin_shape
  s.fill(0)
  s.stroke(255)
  s.stroke_weight(2)
  # Exterior part of shape
  s.vertex(-100,-100)
  s.vertex(100,-100)
  s.vertex(100,100)
  s.vertex(-100,100)
  
  # Interior part of shape
  s.begin_contour
  s.vertex(-10,-10)
  s.vertex(10,-10)
  s.vertex(10,10)
  s.vertex(-10,10)
  s.end_contour
  
  # Finishing off shape
  s.end_shape(CLOSE)
end

def draw
  background(52)
  # Display shape
  translate(width/2, height/2)
  # Shapes can be rotated
  s.rotate(0.01)
  shape(s)
end

