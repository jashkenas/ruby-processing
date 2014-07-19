module PS
  include_package 'org.jbox2d.collision.shapes'
  include_package 'org.jbox2d.common'
  include_package 'org.jbox2d.dynamics'
  java_import 'pbox2d.PBox2D'
  
  
  # Box2D Particle System
  # <http://www.shiffman.net/teaching/nature>
  # Spring 2010
  
  # A class to describe a group of Particles
  # An ArrayList is used to manage the list of Particles 
  
  class ParticleSystem
    
    attr_reader :particles, :x, :y
    
    def initialize(bd, num, x, y)
      @particles = []          # Initialize the ArrayList
      @x, @y = x, y            # Store the origin point  
      num.times do
        particles << PS::Particle.new(bd, x, y)
      end
    end
    
    def run
      # Display all the particles
      particles.each do |p|
        p.display
      end    
      # Particles that leave the screen, we delete them
      # (note they have to be deleted from both the box2d world and our list
      
      particles.each_with_index do |p, i|
        if (p.done)
          particles.delete_at(i)
        end
      end
    end
    
    def add_particles(bd, n)
      n.times do
        particles << PS::Particle.new(bd, x, y)
      end
    end
    
    # A method to test if the particle system still has particles
    def dead  
      particles.empty?
    end
    
  end
  
  # The Nature of Code
  # <http://www.shiffman.net/teaching/nature>
  # Spring 2012
  # PBox2D example
  
  # A Particle
  
  class Particle
    TRAIL_SIZE = 6
    # We need to keep track of a Body
    
    attr_reader :trail, :body, :box2d
    
    # Constructor
    def initialize(b2d, x, y)
      @box2d = b2d
      @trail = Array.new(TRAIL_SIZE, [x, y])
      
      # Add the box to the box2d world
      # Here's a little trick, let's make a tiny tiny radius
      # This way we have collisions, but they don't overwhelm the system
      make_body(PS::Vec2.new(x,y), 0.2)
    end
    
    # This function removes the particle from the box2d world
    def kill_body
      box2d.destroy_body(body)
    end
    
    # Is the particle ready for deletion?
    def done
      # Let's find the screen position of the particle
      pos = box2d.get_body_pixel_coord(body)
      # Is it off the bottom of the screen?
      if (pos.y > $app.height + 20)
        kill_body
        return true
      end
      return false
    end
    
    # Drawing the box
    def display
      # We look at each body and get its screen position
      pos = box2d.get_body_pixel_coord(body)
      
      # Keep track of a history of screen positions in an array
      (TRAIL_SIZE - 1).times do |i|
        trail[i] = trail[i + 1]
      end
      trail[TRAIL_SIZE - 1] = [pos.x, pos.y]
      
      # Draw particle as a trail
      begin_shape
        noFill
        stroke_weight(2)
        stroke(0,150)
        trail.each do |v|
          vertex(v[0], v[1])
        end
      end_shape
    end
    
    # This function adds the rectangle to the box2d world
    def make_body(center, r)
      # Define and create the body
      bd = PS::BodyDef.new
      bd.type = PS::BodyType::DYNAMIC
      
      bd.position.set(box2d.coord_pixels_to_world(center))
      @body = box2d.create_body(bd)
      
      # Give it some initial random velocity
      body.set_linear_velocity(PS::Vec2.new(rand(-1 .. 1), rand(-1 .. 1)))
      
      # Make the body's shape a circle
      cs = PS::CircleShape.new
      cs.m_radius = box2d.scalar_pixels_to_world(r)
      
      fd = PS::FixtureDef.new
      fd.shape = cs
      
      fd.density = 1
      fd.friction = 0  # Slippery when wet!
      fd.restitution = 0.5
      
      # We could use this if we want to turn collisions off
      #cd.filter.groupIndex = -10
      
      # Attach fixture to body
      body.create_fixture(fd)
      
    end
    
  end
  # The Nature of Code
  # <http://www.shiffman.net/teaching/nature>
  # Spring 2012
  # PBox2D example
  
  # A fixed boundary class (now incorporates angle)
  
  
  
  class Boundary
    
    attr_reader :box2d, :b, :x, :y, :w, :h #, :a
    
    def initialize(b2d, x, y, w, h, a)
      @box2d = b2d
      @x = x
      @y = y
      @w = w
      @h = h
      
      # Define the polygon
      sd = PS::PolygonShape.new
      
      # Figure out the box2d coordinates
      box2dW = box2d.scalar_pixels_to_world(w/2)
      box2dH = box2d.scalar_pixels_to_world(h/2)
      # We're just a box
      sd.set_as_box(box2dW, box2dH)
      
      
      # Create the body
      bd = PS::BodyDef.new
      bd.type = PS::BodyType::STATIC
      bd.angle = a
      bd.position.set(box2d.coord_pixels_to_world(x,y))
      @b = box2d.create_body(bd)
      
      # Attached the shape to the body using a Fixture
      b.create_fixture(sd,1)
    end
    
    # Draw the boundary, it doesn't move so we don't have to ask the Body for location
    def display
      fill(0)
      stroke(0)
      stroke_weight(1)
      rect_mode(CENTER)
      a = b.get_angle
      push_matrix
      translate(x,y)
      rotate(-a)
      rect(0,0,w,h)
      pop_matrix
    end
    
  end
  
end
  
  
  
  

