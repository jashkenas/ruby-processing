# Ruby modules, are another way of extending a classes behaviour, the class 
# ParticleSystem includes Enumerable (from ruby core) and our custom Runnable 
# module. Here we use the module Runnable to capture behaviour that can be 
# shared between different classes. Modules are also very useful for wrapping 
# imported classes (wrapped packages can then be called using convenient names).

# This example is bit complicated, because Enumerable and Forwardable are used
# to make the ParticleSystem behave as though it were an Array. This is very
# convenient and is preferred to ParticleSystem subclassing Array.

# Ported from http://processing.org/learning/topics/simpleparticlesystem.html


require 'forwardable'

load_library :vecmath

attr_reader :ps

def setup
  size(640,360)
  @ps = ParticleSystem.new(Vec2D.new(width/2, 50))
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

class ParticleSystem 
  extend Forwardable
  def_delegators(:@particle_system, :each, :<<, :reject!)  
  include Enumerable 
  include Runnable
  
  attr_reader :origin
 
  def initialize(loc)
    @particle_system = []
    @origin = Vec2D.new(loc.x, loc.y)
  end
  
  def add_particle
    self << Particle.new(origin) 
  end
  
end

# A simple Particle class

class Particle 
  include Processing::Proxy 
  
  attr_reader :loc, :vel, :acc, :lifespan
  def initialize(loc) 
    @acc = Vec2D.new(0, 0.05)
    @vel = Vec2D.new(rand(-1.0 .. 1), rand(-2.0 .. 0))
    @loc = loc    # loc.clone is unecessary in ruby
    @lifespan = 255.0
  end

  def run
    update
    display
  end

  # Method to update loc
  def update
    @vel += acc
    @loc += vel
    @lifespan -= 1.0
  end

  # Method to display
  def display
    stroke(255,lifespan)
    fill(255,lifespan)
    ellipse(loc.x, loc.y, 8, 8)
  end
  
end
