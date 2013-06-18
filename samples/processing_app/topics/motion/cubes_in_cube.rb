#
# Cubes Contained Within a Cube 
# by Ira Greenberg.  
# 
# Collision detection against all
# outer cube's surfaces. 
#

# 20 little internal cubes
load_library 'cube'

# Size of outer cube
BOUNDS = 300
CUBE_NO = 20
attr_reader :cubies

def setup
  size(640, 360, P3D)
  @cubies = []
  CUBE_NO.times do 
    # Cubies are randomly sized
    cubie_size = rand(5 .. 15)
    cubies << Cube.new(cubie_size, cubie_size, cubie_size)
  end
  
end

def draw
  background(50)
  lights
  
  # Center in display window
  translate(width/2, height/2, -130)
  
  # Rotate everything, including external large cube
  rotate_x(frame_count * 0.001)
  rotate_y(frame_count * 0.002)
  rotate_z(frame_count * 0.001)
  stroke(255)
  
  
  # Outer transparent cube, just using box method
  no_fill 
  box(BOUNDS)
  
  # Move and rotate cubies
  cubies.each do |c|
    c.update
    c.display
  end
end



