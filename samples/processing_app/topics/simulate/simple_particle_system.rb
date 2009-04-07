# Ported from http://processing.org/learning/topics/simpleparticlesystem.html

# Particles are generated each cycle, fall with gravity and fade out over
# time. A ParticleSystem (Array) object manages a variable size list of
# particles.

module Runnable
  def run
    self.reject! { |particle| particle.dead? }
    self.each    { |particle| particle.run   }
  end
end

class Vector
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def +(other)
    if other.is_a?(Numeric)
      Vector.new(@x + other, @y + other)
    elsif other.is_a?(Vector)
      Vector.new(@x + other.x, @y + other.y)
    else
      self
    end
  end

  def heading
    -1 * Math::atan2(-@y, @x)
  end

  def magnitude
    @x * @x + @y * @y
  end
end

class Sketch < Processing::App
  def setup
    smooth
    color_mode(RGB, 255, 255, 255, 100)
    ellipse_mode(CENTER)

    @particles = []
    @particles.extend Runnable
  end

  def draw
    background 0
    @particles.run
    @particles << Particle.new(Vector.new(mouse_x, mouse_y))
  end

  class Particle
    def initialize(origin)
      @origin = origin
      @velocity = Vector.new(rand * 2 - 1, rand * 2 - 2)
      @acceleration = Vector.new(0, 0.05)
      @radius = 10
      @lifespan = 100
    end

    def run
      update
      grow
      render
      render_velocity_vector
    end
    
    def update
      @velocity += @acceleration
      @origin += @velocity
    end

    def grow
      @lifespan -= 1
    end

    def dead?
      @lifespan <= 0
    end

    def render
      stroke(255, @lifespan)
      fill(100, @lifespan)
      ellipse(@origin.x, @origin.y, @radius, @radius)
    end

    def render_velocity_vector
      scale = 10
      arrow_size = 4

      push_matrix

      translate(@origin.x, @origin.y)
      rotate(@velocity.heading)

      length = @velocity.magnitude * scale

      line 0,      0, length,              0
      line length, 0, length - arrow_size, arrow_size / 2
      line length, 0, length - arrow_size, -arrow_size / 2

      pop_matrix
    end
  end
end

Sketch.new :width => 640, :height => 340
