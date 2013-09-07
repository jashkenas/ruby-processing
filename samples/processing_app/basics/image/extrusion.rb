#
# Extrusion. 
# 
# Converts a flat image into spatial data points and rotates the points
# around the center.
#

attr_reader :a, :values, :angle

def setup
  size(640, 360, P3D)
  @angle = 0
  @values = [] 
  no_fill
  # Load the image into a new array
  # Extract the values and store in an array
  @a = load_image("ystone08.jpg")
  a.load_pixels
  (0 ... a.height).each do |i|
    row = []
    (0 ... a.width).each do |j|
      pix = a.pixels[i*a.width + j]
      row << blue(pix).to_i
    end
    values << row
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
      line(j - a.width/2, i - a.height/2, -values[j][i], j - a.width/2, i - a.height/2, -values[j][i] - 10)
    end
  end
end
