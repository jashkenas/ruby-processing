#
# Acceleration with Vectors 
# by Daniel Shiffman.  
# 
# Demonstration of the basics of motion with vector.
# A "Mover" object stores location, velocity, and acceleration as vectors
# The motion is controlled by affecting the acceleration (in this case towards the mouse)
#
# For more examples of simulating motion and physics with vectors, see 
# Simulate/ForcesWithVectors, Simulate/GravitationalAttraction3D
#

# A Mover object
attr_reader :mover

def setup
  size(640,360)
  @mover = Mover.new(width, height)
end

def draw
  background(0)
  
  # Update the location
  mover.update
  # Display the Mover
  mover.display
end

#
# Acceleration with Vectors 
# by Daniel Shiffman.  
# 
# Demonstration of the basics of motion with vector.
# A "Mover" object stores location, velocity, and acceleration as vectors
# The motion is controlled by affecting the acceleration (in this case towards the mouse)
#


class Mover
  # The Mover tracks location, velocity, and acceleration 
  attr_reader :location, :velocity, :acceleration,
  # The Mover's maximum speed
  :topspeed
  
  def initialize(width, height)
    # Start in the center
    @location = PVector.new(width / 2, height / 2)
    @velocity = PVector.new(0,0)
    @topspeed = 5
  end
  
  def update
    
    # Compute a vector that points from location to mouse
    mouse = PVector.new(mouse_x, mouse_y)
    @acceleration = PVector.sub(mouse, location)
    # Set magnitude of acceleration
    acceleration.set_mag(0.2)
    
    # Velocity changes according to acceleration
    velocity.add(acceleration)
    # Limit the velocity by topspeed
    velocity.limit(topspeed)
    # Location changes by velocity
    location.add(velocity)
  end
  
  def display
    stroke(255)
    stroke_weight(2)
    fill(127)
    ellipse(location.x, location.y, 48, 48)
  end
  
end

