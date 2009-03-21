def setup
  size 320, 320
  @message = "text along a curve"   # The message to be displayed
  @r       = 100                    # The radius of a circle
  text_font create_font("Georgia", 40, true)
  text_align CENTER                 # The text must be centered!
  smooth 
end

def draw
  background 255

  # Start in the center and draw the circle
  translate width/2, height/2 
  no_fill
  ellipse 0, 0, @r*2, @r*2

  # We must keep track of our position along the curve
  arc_length = 0 

  # For every box
  @message.each_byte do |char|
    # Instead of a constant width, we check the width of each character.
    w = text_width(char.chr) 

    # Each box is centered so we move half the width
    arc_length += w / 2

    # Angle in radians is the arc_length divided by the radius
    # Starting on the left side of the circle by adding PI
    theta = PI + arc_length / @r

    push_matrix

    # Polar to Cartesian conversion allows us to find the point along the curve. 
    # See Chapter 13 for a review of this concept.
    translate @r * cos(theta), @r * sin(theta)
    
    # Rotate the box (rotation is offset by 90 degrees)
    rotate theta + PI / 2 

    # Display the character
    fill 0
    text char, 0, 0

    pop_matrix

    # Move halfway again
    arc_length += w / 2 
  end  
end