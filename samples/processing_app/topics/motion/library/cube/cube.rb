# Custom Cube Class


class Cube
  include Processing::Proxy
  
  # Colors are hardcoded
  BOUNDS=300
  COLORS = [0,  51,  102,  153,  204,  255]
  
  # Position, velocity vectors
  attr_reader :position, :velocity, :rotation, :vertices, :w, :h, :d
  
  def initialize(w, h, d)
    @w = w
    @h = h
    @d = d
    
    @vertices = []
    # Start in center
    @position = PVector.new
    # Random velocity vector
    @velocity = PVector.random3D
    # Random rotation
    @rotation = PVector.new(rand(40 .. 100), rand(40 .. 100), rand(40 .. 100))
    
    # cube composed of 6 quads
    #front
    vertices << [-w/2, -h/2, d/2]
    vertices << [w/2, -h/2, d/2]
    vertices << [w/2, h/2, d/2]
    vertices << [-w/2, h/2, d/2]
    #left
    vertices << [-w/2, -h/2, d/2]
    vertices << [-w/2, -h/2, -d/2]
    vertices << [-w/2, h/2, -d/2]
    vertices << [-w/2, h/2, d/2]
    #right
    vertices << [w/2, -h/2, d/2]
    vertices << [w/2, -h/2, -d/2]
    vertices << [w/2, h/2, -d/2]
    vertices << [w/2, h/2, d/2]
    #back
    vertices << [-w/2, -h/2, -d/2]
    vertices << [w/2, -h/2, -d/2]
    vertices << [w/2, h/2, -d/2]
    vertices << [-w/2, h/2, -d/2]
    #top
    vertices << [-w/2, -h/2, d/2]
    vertices << [-w/2, -h/2, -d/2]
    vertices << [w/2, -h/2, -d/2]
    vertices << [w/2, -h/2, d/2]
    #bottom
    vertices << [-w/2, h/2, d/2]
    vertices << [-w/2, h/2, -d/2]
    vertices << [w/2, h/2, -d/2]
    vertices << [w/2, h/2, d/2]
  end 
  
  # Cube shape itself
  def draw_cube
    # Draw cube
    COLORS.length.times do |i|
      fill(COLORS[i])
      begin_shape(QUADS)
        4.times do |j|
          vertex(*vertices[j + 4 * i]) # splat vertices
        end
      end_shape
    end
  end
  
  # Update location
  def update
    position.add(velocity)
    
    # Check wall collisions
    if (position.x > BOUNDS/2 || position.x < -BOUNDS/2)
      velocity.x *= -1
    end
    if (position.y > BOUNDS/2 || position.y < -BOUNDS/2)
      velocity.y *= -1
    end
    if (position.z > BOUNDS/2 || position.z < -BOUNDS/2)
      velocity.z *= -1
    end
  end
  
  
  # Display method
  def display
    push_matrix
    translate(position.x, position.y, position.z)
    rotate_x(frame_count * PI / rotation.x)
    rotate_y(frame_count * PI / rotation.y)
    rotate_z(frame_count * PI /  rotation.z)
    no_stroke
    draw_cube # Farm out shape to another method
    pop_matrix
  end
end
  

