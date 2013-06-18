# The Nature of Code
# <http:#www.shiffman.net/teaching/nature>
# Spring 2010
# PBox2D example

# An uneven surface

load_library :pbox2d
load_library :surface

include SB

attr_reader :surface, :box2d, :particles

def setup
  size(500,300)
  smooth
  
  # Initialize box2d physics and create the world
  @box2d = PBox2D.new(self)
  box2d.create_world
  # We are setting a custom gravity
  box2d.set_gravity(0, -20)
  
  # Create the empty list
  @particles = []
  # Create the surface
  @surface = Surface.new(box2d)
end

def draw
  # If the mouse is pressed, we make new particles
  
  
  # We must always step through time!
  box2d.step
  
  background(138, 66, 54)  
  # Draw the surface
  surface.display
  # NB question mark is reqd to call mouse_pressed value, else method gets called.
  particles << Particle.new(box2d, mouse_x, mouse_y, rand(2.0 .. 6)) if mouse_pressed?    
  # Draw all particles
  particles.each do |p|
    p.display
  end  
  # Particles that leave the screen, we delete them
  # (note they have to be deleted from both the box2d world and our list
  particles.each_with_index do |p, i|
    if (p.done)
      particles.delete_at(i)
    end
  end  
  # Just drawing the framerate to see how many particles it can handle
  fill(0)
  text("framerate: #{frame_rate.to_i}", 12, 16)
end
