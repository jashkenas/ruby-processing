#
# Moving On Curves. 
# 
# In this example, the circles moves along the curve y = x^4.
# Click the mouse to have it move to a new position.
#
STEP = 0.01       # Size of each step along the path

attr_reader :exponent, :begin_x, :begin_y, :end_x, :end_y, :dist_x, :dist_y, :pct, :x, :y

def setup
  size(640, 360)
  @begin_x = 20.0  # Initial x-coordinate
  @begin_y = 10.0  # Initial y-coordinate
  @end_x = 570.0   # Final x-coordinate
  @end_y = 320.0   # Final y-coordinate  
  @exponent = 4   # Determines the curve
  @x = 0.0        # Current x-coordinate
  @y = 0.0        # Current y-coordinate
  @pct = 0.0      # Percentage traveled (0.0 to 1.0)
  no_stroke
  @dist_x = end_x - begin_x
  @dist_y = end_y - begin_y
end

def draw
  fill(0, 2)
  rect(0, 0, width, height)
  @pct += STEP
  if (pct < 1.0)
    @x = begin_x + (pct * dist_x)
    @y = begin_y + (pow(pct, exponent) * dist_y)
  end
  fill(255)
  ellipse(x, y, 20, 20)
end

def mouse_pressed
  @pct = 0.0
  @begin_x = x
  @begin_y = y
  end_x = mouse_x
  end_y = mouse_y
  @dist_x = end_x - begin_x
  @dist_y = end_y - begin_y
end
