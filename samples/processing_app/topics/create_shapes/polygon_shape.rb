
#
# PrimitivePShape. 
# 
# Using a PShape to display a custom polygon. 
#

# The PShape object
attr_reader :star

def setup
  size(640, 360, P2D)
  smooth()
  # First create the shape
  @star = create_shape()
  star.begin_shape()
  # You can set fill and stroke
  star.fill(102)
  star.stroke(255)
  star.stroke_weight(2)
  # Here, we are hardcoding a series of vertices
  star.vertex(0, -50)
  star.vertex(14, -20)
  star.vertex(47, -15)
  star.vertex(23, 7)
  star.vertex(29, 40)
  star.vertex(0, 25)
  star.vertex(-29, 40)
  star.vertex(-23, 7)
  star.vertex(-47, -15)
  star.vertex(-14, -20)
  star.end_shape(CLOSE)
end

def draw
  background(51)
  # We can use translate to move the PShape
  translate(mouseX, mouseY)
  # Display the shape
  shape(star)
end

