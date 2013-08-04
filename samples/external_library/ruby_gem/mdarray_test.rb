#  Demonstrates the syntax for creating a two-dimensional (2D) array,
#  fromfunction (actually a block) using MDArray (for jruby).
#  Values in a 2D array are accessed through two index values.  
#  2D arrays are useful for storing images. In this example, each dot 
#  is colored in relation to its distance from the center of the image.

require 'mdarray'

WIDTH=640
HEIGHT=360
SKIP=10

def setup
  size WIDTH, HEIGHT
  background 0
  stroke_weight 2
  max_distance = ( (WIDTH / 2 - WIDTH)**2  + (HEIGHT / 2 - HEIGHT)**2 )**0.5
  distances = MDArray.fromfunction("float", [WIDTH, HEIGHT]) do |x, y|
    255 * ( (WIDTH / 2 - x)**2  + (HEIGHT / 2 - y)**2 )**0.5 / max_distance
  end
  (SKIP ... WIDTH).step(SKIP) do |x|
      (SKIP ... HEIGHT).step(SKIP) do |y|
        stroke distances[x, y]
        point x, y
      end
  end
end

