def setup
  size 320, 320
  rect_mode CENTER
  smooth
  @r = 100        # The radius of a circle
  @w, @h = 40, 40 # The width and height of the boxes
end

def draw
  background 255

  # Start in the center and draw the circle
  translate width/2, height/2
  no_fill
  stroke 0
  
  # Our curve is a circle with radius r in the center of the window.
  ellipse 0, 0, @r*2, @r*2

  # 10 boxes along the curve
  total_boxes = 10

  # @we must keep track of our position along the curve
  arc_length = 0

  # For every box
  total_boxes.times do |i|
    # Each box is centered so we move half the width
    arc_length += @w / 2.0

    # Angle in radians is the arclength divided by the radius
    theta = arc_length / @r

    push_matrix
    # Polar to cartesian coordinate conversion
    translate @r * cos(theta), @r * sin(theta)

    # @rotate the box
    rotate theta

    # Display the box
    fill 0, 100
    rect 0, 0, @w, @h
    pop_matrix

    # Move halfway again
    arc_length += @w / 2  
  end
end