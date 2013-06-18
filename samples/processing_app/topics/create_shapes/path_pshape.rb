#
# PathPShape
# 
# A simple path using PShape
#

# A PShape object
attr_reader :path

def setup
  size(640, 360, P2D)
  smooth
  # Create the shape
  @path = create_shape
  path.begin_shape
  # Set fill and stroke
  path.noFill
  path.stroke(255)
  path.stroke_weight(2)
  
  x = 0
  # Calculate the path as a sine wave
  (0 .. TWO_PI).step(0.1) do |theta|
    path.vertex(x,sin(theta)*100)
    x += 5
  end
  # The path is complete
  path.end_shape  

end

def draw
  background(51)
  # Draw the path at the mouse location
  translate(mouse_x, mouse_y)
  shape(path)
end

