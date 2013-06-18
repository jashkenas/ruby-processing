#
# Koch Curve
# by Daniel Shiffman.
# 
# Renders a simple fractal, the Koch snowflake. 
# Each recursive level is drawn in sequence. 
#

load_library 'koch'

attr_reader :k

def setup
  size(640, 360)
  frame_rate(1)  # Animate slowly
  @k = KochFractal.new(width, height)
end

def draw
  background(0)
  # Draws the snowflake!
  k.render
  # Iterate
  k.next_level
  # Let's not do it more than 5 times. . .
  if (k.get_count > 5) 
    k.restart
  end
end
