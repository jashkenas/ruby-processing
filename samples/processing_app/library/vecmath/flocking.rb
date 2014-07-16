#
# Flocking 
# by Daniel Shiffman.  
# 
# An implementation of Craig Reynold's Boids program to simulate
# the flocking behavior of birds. Each boid steers itself based on 
# rules of avoidance, alignment, and coherence.
# 
# Click the mouse to add a new boid.
#
load_library :vecmath # load_library required by flock library 
load_library :flock

attr_reader :flock

def setup
  size(640, 360)
  # Add an initial set of boids into the system at the center
  @flock = Flock.new(150, Vec2D.new(width / 2.0, height / 2.0))
end

def draw
  background(50)
  flock.run
end

# Add a new boid into the System
def mouse_pressed
  flock << Boid.new(Vec2D.new(mouse_x, mouse_y))
end
