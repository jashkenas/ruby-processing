# Ported from http://processing.org/learning/topics/simpleparticlesystem.html

# Particles are generated each cycle, fall with gravity and fade out over
# time. A ParticleSystem (Array) object manages a variable size list of
# particles.

attr_reader :ps

def setup
  size(640,360)
  @ps = ParticleSystem.new(PVector.new(width/2, 50))
  @ps.extend Runnable
end

def draw
  background(0)
  ps.add_particle
  ps.run
end

module Runnable
  def run
    self.reject! { |item| item.lifespan <= 0 }
    self.each    { |item| item.run   }
  end
end

class ParticleSystem < Array  
  include Runnable
  attr_reader :origin

  def initialize(loc)
    super() # paren required to prevent array trying to initialize with PVector
    @origin = loc.get
  end

  def add_particle
    self << Particle.new(origin) # ParticleSytem is extending Array
  end

end

# A simple Particle class

class Particle 
  include Processing::Proxy    
  attr_reader :loc, :vel, :acc, :lifespan
  def initialize(l) 
    @acc = PVector.new(0, 0.05)
    @vel = PVector.new(rand * 2 - 1, rand * 2 - 2)
    @loc = l.get
    @lifespan = 255.0
  end

  def run
    update
    display
  end

  # Method to update loc
  def update
    vel.add(acc)
    loc.add(vel)
    @lifespan -= 1.0
  end

  # Method to display
  def display
    stroke(255,lifespan)
    fill(255,lifespan)
    ellipse(loc.x, loc.y, 8, 8)
  end
  
end
