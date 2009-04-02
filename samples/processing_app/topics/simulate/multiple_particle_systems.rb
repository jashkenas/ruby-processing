# Ported from http://processing.org/learning/topics/multipleparticlesystems.html

# Click the mouse to generate a burst of particles at mouse location.

# Each burst is one instance of a particle system with Particles and
# CrazyParticles (a subclass of Particle).

module Runnable
  def run
    self.reject! { |item| item.dead? }
    self.each    { |item| item.run   }
  end
end


class Vector
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def +(other)
    return Vector.new(@x + other, @y + other)     if other.is_a?(Numeric)
    return Vector.new(@x + other.x, @y + other.y) if other.is_a?(Vector)
    self
  end

  def heading
    -1 * Math::atan2(-@y, @x)
  end

  def magnitude
    @x * @x + @y * @y
  end
end


class ParticleSystem < Array
  include Runnable
  alias_method :dead?, :empty?

  def initialize(number, origin)
    super()
    @origin = origin
    kind = rand < 0.5 ? Sketch::Particle : Sketch::CrazyParticle
    number.times { self << kind.new(origin) }
  end
end


class Sketch < Processing::App
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
    origin = rand(21) + 5
    vector = Vector.new(mouse_x, mouse_y)
    @particle_systems << ParticleSystem.new(origin, vector)
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

      line 0, 0, length, 0
      line length, 0, length - arrow_size, arrow_size / 2
      line length, 0, length - arrow_size, -arrow_size / 2
      
      pop_matrix
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
      push_matrix
      
      translate(@origin.x, @origin.y)
      rotate(@theta)
      
      stroke(255, @lifespan)
      
      line(0, 0, 25, 0)
      
      pop_matrix
    end
  end
  
end

Sketch.new :width => 640, :height => 340
