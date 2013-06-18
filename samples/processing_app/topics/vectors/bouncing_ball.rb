#
# Bouncing Ball with Vectors 
# by Daniel Shiffman.  
# 
# Demonstration of using vectors to control motion of body
# This example is not object-oriented
# See AccelerationWithVectors for an example of how to simulate motion using vectors in an object
#
 
attr_reader :location,  # Location of shape
            :velocity,  # Velocity of shape
            :gravity   # Gravity acts at the shape's acceleration

def setup
  size(640,360)
  smooth
  @location = PVector.new(100,100)
  @velocity = PVector.new(1.5,2.1)
  @gravity = PVector.new(0,0.2)

end

def draw
  background(0)
  
  # Add velocity to the location.
  location.add(velocity)
  # Add gravity to velocity
  velocity.add(gravity)
  
  # Bounce off edges
if ((location.x > width) || (location.x < 0))
    velocity.x = velocity.x * -1
  end
if (location.y > height)
    # We're reducing velocity ever so slightly 
    # when it hits the bottom of the window
    velocity.y = velocity.y * -0.95 
    location.y = height
  end

  # Display circle at location vector
  stroke(255)
  stroke_weight(2)
  fill(127)
  ellipse(location.x,location.y,48,48)
end


