
# TRIANGLE_STRIP Mode
# by Ira Greenberg.
#
# Generate a closed ring using vertex()
# function and begin_shape(TRIANGLE_STRIP) mode
# using outer_radius and inner_radius variables to
# control ring's outer/inner radii respectively.
# Trig functions generate ring.
attr_reader :x, :y, :outer_radius, :inner_radius

def setup
  size 640, 360  
  @x = width/2
  @y = height/2
  @outer_radius = min(width, height) * 0.4
  @inner_radius = outer_radius * 0.6
end

def draw
  background 204
  pts = map(mouse_x, 0, width, 6, 60).to_i
  angle = 0.0      # degrees
  step = 180.0/pts # degrees
  
  begin_shape TRIANGLE_STRIP
  (0 .. pts).each do 
    px = x + cos(angle.radians)*outer_radius
    py = y + sin(angle.radians)*outer_radius
    angle += step
    vertex px, py
    
    px = x + cos(angle.radians)*inner_radius
    py = y + sin(angle.radians)*inner_radius
    angle += step
    vertex px, py
  end
  end_shape
end
