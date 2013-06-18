#
# Non-orthogonal Collision with Multiple Segments 
# by Ira Greenberg. 
# 
# Based on Keith Peter's Solution in
# Foundation Actionscript Animation: Making Things Move!


load_library 'ground'

GRAVITY = Vect.new(0, 0.05)
DAMPING = 0.8
SEGS = 40
attr_accessor :orb, :velocity
attr_reader :ground, :peakHeights

def setup
  size(640, 360)
  @orb = Orb.new(50.0, 50.0, 3.0)
  @velocity = Vect.new(0.5, 0.0)
  # Initialize ground peak heights 
  @peakHeights = []
  (SEGS + 1).times do
    @peakHeights << rand(height - 40.0 .. height - 30.0)
  end
  @ground = []  
  
  # Float value required for segment width 
  # calculations so the ground spans the entire 
  # display window, regardless of segment number.
  
  SEGS.times do |i|
    @ground << Ground.new(width.to_f/SEGS*i, peakHeights[i], width.to_f/SEGS*(i+1), peakHeights[i+1])
  end
end


def draw
  # Background
  no_stroke
  fill(0, 0, 40, 15)
  rect(0, 0, width, height)
  
  # Move orb
  velocity.add(GRAVITY)
  orb.move(velocity)
  
  # Draw ground
  fill(127, 80, 70)
  begin_shape()
  ground.each do |seg|
    vertex(seg.x1, seg.y1)
    vertex(seg.x2, seg.y2)
  end
  vertex(ground[SEGS - 1].x2, height)
  vertex(ground[0].x1, height)
  end_shape(CLOSE)
  
  # Draw orb
  no_stroke
  fill(200)
  ellipse(orb.x, orb.y, orb.r * 2, orb.r * 2)
  
  # Collision detection
  check_wall_collision
  ground.each do |seg|
    check_ground_collision(seg)
  end
end


def check_wall_collision
  if (orb.x > width-orb.r)
    orb.x = width-orb.r
    velocity.x *= -DAMPING
    
  elsif (orb.x < orb.r)
    orb.x = orb.r
    velocity.x *= -DAMPING
  end
end


def check_ground_collision(ground_segment)
  
  # Get difference between orb and ground
  dx = orb.x - ground_segment.x
  dy = orb.y - ground_segment.y
  
  # Precalculate trig values
  cosine = cos(ground_segment.rot)
  sine = sin(ground_segment.rot)
  
  #  Rotate ground and velocity to allow 
  # orthogonal collision calculations
  ground_x_temp = cosine * dx + sine * dy
  ground_y_temp = cosine * dy - sine * dx
  velocity_x_temp = cosine * velocity.x + sine * velocity.y
  velocity_y_temp = cosine * velocity.y - sine * velocity.x
  
  # collision - check for surface 
  # collision and also that orb is within 
  # left/rights bounds of ground segment
  if (ground_y_temp + orb.r) > EPSILON * 5 
    if (orb.x > ground_segment.x1) && (orb.x < ground_segment.x2)
      # keep orb from going into ground
      ground_y_temp = -orb.r 
      # bounce and slow down orb
      velocity_y_temp *= -DAMPING
    end
  end
  
  # Reset ground, velocity and orb
  dx = cosine * ground_x_temp - sine * ground_y_temp
  dy = cosine * ground_y_temp + sine * ground_x_temp
  @velocity.x = cosine * velocity_x_temp - sine * velocity_y_temp
  @velocity.y = cosine * velocity_y_temp + sine * velocity_x_temp
  @orb.x = ground_segment.x + dx
  @orb.y = ground_segment.y + dy
end


