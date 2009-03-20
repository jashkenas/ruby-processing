#
# Example 17-8: Characters along a curve
#
def setup
  size 320, 320
  @message = "text along a curve" # The message to be displayed
  @r       = 100                  # The radius of a circle
  textFont createFont("Georgia", 40, true)
  textAlign CENTER                # The text must be centered!
  smooth 
end

def draw
  background 255

  # Start in the center and draw the circle
  translate width / 2, height / 2 
  noFill
  stroke 0
  ellipse 0, 0, @r * 2, @r * 2

  # We must keep track of our position along the curve
  arclength = 0 

  # For every box
  @message.each_byte do |char|
    # The character and its width
    currentChar = char.chr

    # Instead of a constant width, we check the width of each character.
    w = textWidth(currentChar) 

    # Each box is centered so we move half the width
    arclength += w / 2

    # Angle in radians is the arclength divided by the radius
    # Starting on the left side of the circle by adding PI
    theta = PI + arclength / @r

    pushMatrix

    # Polar to Cartesian conversion allows us to find the point along the curve. 
    # See Chapter 13 for a review of this concept.
    translate @r * cos(theta), @r * sin(theta)

    # Rotate the box (rotation is offset by 90 degrees)
    rotate theta + PI / 2 

    # Display the character
    fill 0
    text currentChar, 0, 0

    popMatrix

    # Move halfway again
    arclength += w / 2 
  end  
end
