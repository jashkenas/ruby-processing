#
# Noise Wave
# by Daniel Shiffman.  
# 
# Using Perlin Noise to generate a wave-like pattern. 
#

attr_reader :yoff         # 2nd dimension of perlin noise

def setup
  size(640, 360)
  @yoff = 0.0        
end

def draw
  background(51)

  fill(255)
  # We are going to draw a polygon out of the wave points
  begin_shape 
  
  xoff = 0       # Option #1: 2D Noise
  # xoff = yoff # Option #2: 1D Noise
  
  # Iterate over horizontal pixels
  (0 .. width).step(10) do |x|
    # Calculate a y value according to noise, map to 
    y = map(noise(xoff, yoff), 0, 1, 200,300) # Option #1: 2D Noise
    # y = map(noise(xoff), 0, 1, 200,300)    # Option #2: 1D Noise
    
    # Set the vertex
    vertex(x, y) 
    # Increment x dimension for noise
    xoff += 0.05
  end
  # increment y dimension for noise
  @yoff += 0.01
  vertex(width, height)
  vertex(0, height)
  end_shape(CLOSE)
end
