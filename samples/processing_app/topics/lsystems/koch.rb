load_library :vecmath, :fastmath, :koch

def setup
  size(800, 250)
  background(255)
  frame_rate(1)  # Animate slowly
  @k = KochFractal.new(width, height)
  smooth 8
end

def draw
  background(255)
  # Draws the snowflake!
  @k.render
  # Iterate
  @k.next_level
  # Let's not do it more than 5 times. . .
  @k.restart if @k.count > 5
end
