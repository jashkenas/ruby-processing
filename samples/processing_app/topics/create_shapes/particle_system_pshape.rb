#
# ParticleSystemPShape
# A particle system optimized for drawing using PShape
# For guts of implementation see 'particle' library
#

load_library 'particle'

# Particle System object and image
attr_reader :ps 

def setup
  size(640, 360, P2D)
  # Load the image
  sprite = loadImage("sprite.png")
  # A new particle system with 10,000 particles
  @ps = ParticleSystem.new(width, height, sprite, 10000)
  # Writing to the depth buffer is disabled to avoid rendering
  # artifacts due to the fact that the particles are semi-transparent
  # but not z-sorted.
  hint(DISABLE_DEPTH_MASK)
end 

def draw 
  background(0)
  # Update and display system
  ps.update
  ps.display
  # Set the particle system's emitter location to the mouse
  ps.set_emitter(mouse_x, mouse_y)
  
  # Display frame rate
  fill(255, 0, 255)
  text_size(16)
  text("Frame rate: #{frame_rate.round(1)}", 10, 20)
  
end

