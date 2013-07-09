# The createImage() function provides a fresh buffer of pixels to play with.
# This example creates an image gradient.


def setup
  size 640, 360
  @image = create_image 230, 230, ARGB
  @image.pixels.length.times do |i|
    @image.pixels[i] = color 0, 90, 102, (i % @image.width * 2) # red, green, blue, alpha
  end
end

def draw
  background 204
  image @image, 90, 80
  image @image, mouse_x-@image.width, mouse_y-@image.width
end
