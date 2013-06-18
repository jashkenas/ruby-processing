# Ported from http://processing.org/learning/topics/smokeparticlesystem.html

# A ParticleSystem (Array) object manages a variable size list of
# particles.

attr_reader :ps, :img, :wind

def setup
  size(640,360)
  @img = loadImage("texture.png")
  @ps = ParticleSystem.new(0, PVector.new(width/2,height-60), img)
  @ps.extend Runnable
end

def draw
  background(0)  
  # Calculate a "wind" force based on mouse horizontal position
  dx = map(mouse_x, 0, width, -0.2, 0.2)
  @wind = PVector.new(dx, 0)
  ps.apply_force(wind)
  ps.run
  2.times do
    ps.add_particle
  end
  
  # Draw a horizontal arrow representing the wind force
  draw_vector(wind, PVector.new(width / 2, 50, 0), 500)
  
end

# Renders a vector object 'v' as an arrow and a location 'loc'
def draw_vector(v, loc, scayl)
  push_matrix
  # Translate to location to render vector
  translate(loc.x, loc.y)  
  rotate(v.heading2D)
  # Calculate length of vector & scale as necessary
  len = v.mag * scayl
  # Draw three lines to make an arrow 
  arrowsize = 4
  stroke(255)
  stroke_weight 2
  line(0, 0, len, 0)
  stroke_weight 1
  line(len, 0, len - arrowsize, +arrowsize/2)
  line(len, 0, len - arrowsize, -arrowsize/2)
  pop_matrix
end

module Runnable
  def run
    self.reject! { |item| item.lifespan <= 0 }
    self.each    { |item| item.run }
  end
end


class ParticleSystem < Array
  include Runnable
  attr_reader :particles, :origin, :image, :generator
  def initialize(num, location, image)
    super()
    @origin = location.get
    @image = image
    @particles = []
    (0 ... num).each do
      self << Particle.new(origin, image)
    end
  end
  
  def add_particle(p = Particle.new(origin, image))
    self << p
  end
  
  # Method to add a force vector to all particles currently in the system
  def apply_force(dir) 
    self.each do |p|
      p.apply_force(dir)
    end  
  end 
end

# A simple Particle class

class Particle 
  include Processing::Proxy 
  
  attr_reader :loc, :acc, :vel, :lifespan, :img, :generator
  
  def initialize(l, img_) 
    @acc = PVector.new(0,0)
    vx = random_gaussian * 0.3
    vy = random_gaussian * 0.3 - 1.0
    @vel = PVector.new(vx, vy)
    @loc = l.get()
    @lifespan = 100.0
    @img = img_
  end
  
  def run
    update
    render
  end
  
  # Method to update location
  def update
    vel.add(acc)
    loc.add(vel)
    @lifespan -= 1.0
  end
  
  # Method to display
  def render() 
    image_mode(CENTER)
    tint(255,lifespan)
    image(img,loc.x,loc.y)
  end
  
  # Method to add a force vector to all particles currently in the system
  def apply_force(f) 
    @acc.add(f)
  end
  
end


