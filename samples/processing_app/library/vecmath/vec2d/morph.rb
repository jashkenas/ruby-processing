#
# Morph.
# 
# Changing one shape into another by interpolating
# vertices from one to another
#
load_library :vecmath

attr_reader :circle, :square, :morph, :state, :v1, :v2, :renderer

ALPHA = Math::PI / 4.0
OMEGA = TAU + ALPHA
THETA = Math::PI / 20.0

def setup
  size(640, 360)
  @circle = []
  @square = []
  @morph = []
  @state = false
  @renderer = AppRender.new(self)
  frame_rate(15)
  # Create a circle using vectors pointing from center
  (ALPHA .. OMEGA).step(THETA) do |angle|
    # Note we are not starting from 0 in order to match the
    # path of a circle.
    circle << Vec2D.from_angle(angle) * 100
    # Let's fill out morph Array with blank Vec2Ds while we are at it
    morph << Vec2D.new
  end

  # A square is a bunch of vertices along straight line
  # Top of square
  (-50 .. 50).step(10) do |x|
    square << Vec2D.new(x, -50)
  end
  # Right side
  (-50 .. 50).step(10) do |y|
    square << Vec2D.new(50, y)
  end
  # Bottom, NB: can't negative step ruby so use your loaf
  5.downto(-5) do |x|
    square << Vec2D.new(x * 10, 50)
  end
  # Left side
  5.downto(-5) do |y|
    square << Vec2D.new(-50, y * 10)
  end
end

def draw
  background(51)

  # We will keep how far the vertices are from their target
  @total_distance = 0
  
  # Look at each vertex
  circle.length.times do |i|
    # Are we lerping to the circle or square?
    v1 = state ?  circle[i] : square[i]
    # Get the vertex we will draw
    v2 = morph[i]
    
    # Lerp to the target
    v2.lerp!(v1, 0.1)
    # Check how far we are from target
    @total_distance += v1.dist(v2)
  end
  
  # If all the vertices are close, switch shape
  @state = !state if @total_distance < 0.08
  
  # Draw relative to center
  translate(width / 2, height / 2)
  stroke_weight(4)
  # Draw a polygon that makes up all the vertices
  begin_shape
  no_fill
  stroke(255)
  morph.each do |v|
    v.to_vertex(renderer)
  end
  end_shape(CLOSE)
end



