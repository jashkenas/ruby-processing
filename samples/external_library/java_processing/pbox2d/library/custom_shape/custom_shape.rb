module B2D
  include_package 'pbox2d'
  include_package 'org.jbox2d.collision.shapes'
  include_package 'org.jbox2d.common'
  include_package 'org.jbox2d.dynamics'
  java_import 'pbox2d.PBox2D'
  
  
  # The Nature of Code
  # <http://www.shiffman.net/teaching/nature>
  # Spring 2011
  # PBox2D example
  # A rectangular box
  
  class CustomShape

    # We need to keep track of a Body and a width and height
    attr_reader :body, :box2d
    
    # Constructor
    def initialize(b2d, x, y)
      # Add the box to the box2d world
      @box2d = b2d  
      make_body(B2D::Vec2.new(x, y))          
    end
    
    # This function removes the particle from the box2d world
    def kill_body!
      box2d.destroy_body(body)
    end
    
    # Is the particle ready for deletion?
    def done
      # Let's find the screen position of the particle
      pos = box2d.get_body_pixel_coord(body)
      # Is it off the bottom of the screen?
      if (pos.y > $app.height)
        kill_body!
        return true
      end
      return false
    end
    
    # Drawing the box
    def display
      # We look at each body and get its screen position
      pos = box2d.get_body_pixel_coord(body)
      # Get its angle of rotation
      a = body.get_angle
      
      f = body.get_fixture_list
      ps = f.get_shape
      
      
      rect_mode(CENTER)
      push_matrix
      translate(pos.x, pos.y)
      rotate(-a)
      fill(175)
      stroke(0)
      begin_shape
        # For every vertex, convert to pixel vector
        ps.get_vertex_count.times do |i|
          v = box2d.vector_world_to_pixels(ps.get_vertex(i))
          vertex(v.x, v.y)
        end
      end_shape(CLOSE)
      pop_matrix
    end
    
    # This function adds the rectangle to the box2d world
    def make_body(center)
      
      # Define a polygon (this is what we use for a rectangle)
      sd = B2D::PolygonShape.new
      
      vertices = []
      vertices << box2d.vector_pixels_to_world(B2D::Vec2.new(-15, 25))
      vertices << box2d.vector_pixels_to_world(B2D::Vec2.new(15, 0))
      vertices << box2d.vector_pixels_to_world(B2D::Vec2.new(20, -15))
      vertices << box2d.vector_pixels_to_world(B2D::Vec2.new(-10, -10))
      sd.set(vertices.to_java(Java::OrgJbox2dCommon::Vec2), vertices.length)
      
      # Define the body and make it from the shape
      bd = B2D::BodyDef.new
      bd.type = B2D::BodyType::DYNAMIC
      bd.position.set(box2d.coord_pixels_to_world(center))
      @body = box2d.create_body(bd)
      
      body.create_fixture(sd, 1.0)
      
      
      # Give it some initial random velocity
      body.set_linear_velocity(Vec2.new(rand(-5 .. 5), rand(2 .. 5)))
      body.set_angular_velocity(rand(-5 .. 5))
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
      sd = B2D::PolygonShape.new

      # Figure out the box2d coordinates
      box2dW = box2d.scalar_pixels_to_world(w/2)
      box2dH = box2d.scalar_pixels_to_world(h/2)
      # We're just a box
      sd.set_as_box(box2dW, box2dH)
      
      
      # Create the body
      bd = B2D::BodyDef.new
      bd.type = B2D::BodyType::STATIC
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
  
  

