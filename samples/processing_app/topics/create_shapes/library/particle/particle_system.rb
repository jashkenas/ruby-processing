# The Particle System

class ParticleSystem 
  include Processing::Proxy

  attr_reader :particles, :particle_shape#, :width, :height, :sprite

  def initialize(width, height, sprite, n) 
    #width, height, sprite = width, height, sprite
    @particles = []
    # The PShape is a group
    @particle_shape = create_shape(GROUP)

    # Make all the Particles
    n.times do |i|       
      particles << Particle.new(width, height, sprite)
      # Each particle's PShape gets added to the System PShape
      particle_shape.add_child(particles[i].s_shape)
    end
  end

  def update
    particles.each do |p|
      p.update
    end
  end

  def set_emitter(x, y) 
    particles.each do |p|
      # Each particle gets reborn at the emitter location     
      p.rebirth(x, y) if (p.dead?) 
    end
  end

  def display
    shape(particle_shape)
  end
end

# An individual Particle

class Particle
  include Processing::Proxy
  
  GRAVITY = PVector.new(0, 0.1) 
  
  attr_reader :center, :velocity, :lifespan, :s_shape, :part_size, 
  :width, :height, :sprite
 

  def initialize width, height, sprite
    @width, @height, @sprite = width, height, sprite
    part_size = rand(10 .. 60)
    # The particle is a textured quad
    @s_shape = create_shape
    s_shape.begin_shape(QUAD)
    s_shape.no_stroke
    s_shape.texture(sprite)
    s_shape.normal(0, 0, 1)
    s_shape.vertex(-part_size/2, -part_size/2, 0, 0)
    s_shape.vertex(+part_size/2, -part_size/2, sprite.width, 0)
    s_shape.vertex(+part_size/2, +part_size/2, sprite.width, sprite.height)
    s_shape.vertex(-part_size/2, +part_size/2, 0, sprite.height)
    s_shape.end_shape

    # Initialize center vector
    @center = PVector.new 
    
    # Set the particle starting location
    rebirth(width/2, height/2)
  end

  def rebirth(x, y)
    theta = rand(-PI .. PI)
    speed = rand(0.5 .. 4)
    # A velocity with random angle and magnitude
    @velocity = PVector.from_angle(theta)
    @velocity.mult(speed)
    # Set lifespan
    @lifespan = 255
    # Set location using translate
    s_shape.reset_matrix
    s_shape.translate(x, y) 
    
    # Update center vector
    @center.set(x, y, 0)
  end

  # Is it off the screen, or its lifespan is over?
  def dead?
    (center.x > width  || center.x < 0 || 
        center.y > height || center.y < 0 || lifespan < 0)
  end

  def update
    # Decrease life
    @lifespan = lifespan - 1
    # Apply gravity
    velocity.add(GRAVITY)
    s_shape.setTint(color(255, lifespan))
    # Move the particle according to its velocity
    s_shape.translate(velocity.x, velocity.y)
    # and also update the center
    center.add(velocity)
  end
end

