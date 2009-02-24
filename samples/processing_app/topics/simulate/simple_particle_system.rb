# Ported from http://processing.org/learning/topics/simpleparticlesystem.html

# Particles are generated each cycle, fall with gravity and fade out over
# time. A ParticleSystem (Array) object manages a variable size list of
# particles.

require 'ruby-processing'

class SimpleParticleSystem < Processing::App
  def setup
    smooth
    color_mode(Processing::App::RGB, 255, 255, 255, 100)

    @particles = []
    @particles.extend Runnable
  end

  def draw
    background 0
    @particles.run
    @particles << Particle.new(Vector.new(mouse_x, mouse_y))
  end

  module Runnable
    def run
      self.reject! { |particle| particle.dead? }
      self.each { |particle| particle.run }
    end
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

    def grow
      @lifespan -= 1
    end

    def dead?
      @lifespan <= 0
    end

    def update
      @velocity += @acceleration
      @origin += @velocity
    end

    def render
      $app.ellipse_mode(Processing::App::CENTER)
      $app.stroke(255, @lifespan)
      $app.fill(100, @lifespan)
      $app.ellipse(@origin.x, @origin.y, @radius, @radius)
    end

    def render_velocity_vector
      scale = 10
      arrow_size = 4

      $app.push_matrix

      $app.translate(@origin.x, @origin.y)
      $app.rotate(@velocity.heading)

      length = @velocity.magnitude * scale

      $app.stroke(255, @lifespan)
      $app.line 0, 0, length, 0
      $app.line length, 0, length - arrow_size, arrow_size / 2
      $app.line length, 0, length - arrow_size, -arrow_size / 2

      $app.pop_matrix
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
end

$app = SimpleParticleSystem.new :width => 640, :height => 340, :title => 'SimpleParticleSystem'
