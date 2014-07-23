#
# Bouncing Ball with Vectors 
# by Daniel Shiffman.  
# PVector was used in the original (instead of Vec2D)
#
# Demonstration of using vectors to control motion of body
# This example is not object-oriented
# See AccelerationWithVectors for an example of how to simulate motion using vectors in an object
#
load_library :vecmath
RADIUS = 24

attr_reader :loc,  # Location of shape
            :velocity,  # Velocity of shape
            :gravity   # Gravity acts at the shape's acceleration

def setup
  size(640, 360)
  smooth 4
  @loc = Vec2D.new(100, 100)
  @velocity = Vec2D.new(1.5, 2.1)
  @gravity = Vec2D.new(0, 0.2)

end

def draw
  background(0)
  # Add velocity to the location.
  @loc += velocity
  # Add gravity to velocity
  @velocity += gravity
  # Bounce off edges
  velocity.x *= -1 unless (RADIUS .. width - RADIUS).include?(loc.x)
  if loc.y > (height - RADIUS)
    # We're reducing velocity ever so slightly 
    # when it hits the bottom of the window
    velocity.y *= -0.95 
    loc.y = height - RADIUS
  end
  # Display circle at location vector
  stroke(255)
  stroke_weight(2)
  fill(127)
  ellipse(loc.x, loc.y, RADIUS * 2, RADIUS * 2)
end
