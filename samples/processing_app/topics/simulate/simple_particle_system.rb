# Ported from http://processing.org/learning/topics/simpleparticlesystem.html

# Particles are generated each cycle, fall with gravity and fade out over
# time. A ParticleSystem (Array) object manages a variable size list of
# particles.
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
    reject! { |item| item.lifespan <= 0 }
    each    { |item| item.run   }
  end
end

class ParticleSystem
  include Enumerable, Runnable
  extend Forwardable
  def_delegators(:@particles, :reject!, :<<, :each, :empty?)
  def_delegator(:@particles, :empty?, :dead?)

  attr_reader :origin

  def initialize(loc)
    @particles = []
    @origin = loc
  end

  def add_particle
    self << Particle.new(origin)
  end
end

# A simple Particle class

class Particle
  include Processing::Proxy

  attr_reader :loc, :vel, :acc, :lifespan
  def initialize(l)
    @acc = Vec2D.new(0, 0.05)
    @vel = Vec2D.new(rand(-1.0..1), rand(-2.0..0))
    @loc = l.copy
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
