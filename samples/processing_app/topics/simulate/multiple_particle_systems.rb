# Ported from http://processing.org/learning/topics/multipleparticlesystems.html

# Click the mouse to generate a burst of particles at mouse location.

# Each burst is one instance of a particle system with Particles and
# CrazyParticles (a subclass of Particle).


require 'ruby-processing'

class MultipleParticleSystems < Processing::App
  def setup
    smooth
    color_mode(RGB, 255, 255, 255, 100)
    ellipse_mode(CENTER)

    @particle_systems = []
    @particle_systems.extend Runnable
  end

  def draw
    background 0
    @particle_systems.run
  end

  def mouse_pressed
    @particle_systems << ParticleSystem.new(rand(21) + 5, Vector.new(mouse_x, mouse_y))
  end

  module Runnable
    def run
      self.reject! { |item| item.dead? }
      self.each    { |item| item.run   }
    end
  end

  class ParticleSystem < Array
    include Runnable
    alias_method :dead?, :empty?

    def initialize(number, origin)
      super()
      @origin = origin
      kind = rand < 0.5 ? Particle : CrazyParticle
      number.times { self << kind.new(origin) }
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

      $app.line 0, 0, length, 0
      $app.line length, 0, length - arrow_size, arrow_size / 2
      $app.line length, 0, length - arrow_size, -arrow_size / 2

      $app.pop_matrix
    end
  end

  class CrazyParticle < Particle
    def initialize(origin)
      super
      @theta = 0
    end

    def run
      update
      grow
      render
      render_rotation_line
    end
    
    def update
      super
      @theta += @velocity.x * @velocity.magnitude / 10
    end

    def grow
      @lifespan -= 0.8
    end

    def render_rotation_line
      $app.push_matrix

      $app.translate(@origin.x, @origin.y)
      $app.rotate(@theta)

      $app.stroke(255, @lifespan)

      $app.line(0, 0, 25, 0)

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

$app = MultipleParticleSystems.new :width => 640, :height => 340, :title => 'MultipleParticleSystems'
