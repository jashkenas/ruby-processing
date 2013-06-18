#
# Extrusion. 
# 
# Converts a flat image into spatial data points and rotates the points
# around the center.
#

attr_reader :a, :a_pixels, :values, :angle

def setup
  size(640, 360, P3D)
  @angle = 0
  @a_pixels = []
  @values = []
  no_fill
  
  # Load the image into a new array
  # Extract the values and store in an array
  @a = load_image("ystone08.jpg")
  a.load_pixels
  (0 ... a.height).each do |j|
    a_inner = []
    v_inner = []
    (0 ... a.width).each do |i|
      a_inner << a.pixels[i * a.width + j]
      v_inner << blue(a_inner[i]).to_i
    end
    a_pixels << a_inner
    values << v_inner
  end
end

def draw
  background(0)
  translate(width/2, height/2, -height/2)
  scale(2.0)
  
  # Update and constrain the angle
  @angle += 0.005
  rotate_y(angle)  
  
  # Display the image mass
  (0 ... a.height).step(4) do |i|
    (0 ... a.width).step(4) do |j|
      stroke(values[j][i], 255)
      line(j-a.width/2, i-a.height/2, -values[j][i], j-a.width/2, i-a.height/2, -values[j][i]-10)
    end
  end
end
