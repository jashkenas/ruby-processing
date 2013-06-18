#
# Brightness
# by Daniel Shiffman. 
# 
# This program adjusts the brightness of a part of the image by
# calculating the distance of each pixel to the mouse.
#

 

attr_reader :img

def setup
  size(640, 360)
  frame_rate(30)
  @img = load_image("moon-wide.jpg")
  img.load_pixels
  # Only need to load the pixels[] array once, because we're only
  # manipulating pixels[] inside draw, not drawing shapes.
  load_pixels
end

def draw
  (0 ... img.width).each do |x|
    (0 ... img.height).each do |y|
      # Calculate the 1D location from a 2D grid
      loc = x + y * img.width
      r = red (img.pixels[loc])
      # Calculate an amount to change brightness based on proximity to the mouse
      maxdist = 50 # dist(0,0,width,height)
      d = dist(x, y, mouseX, mouseY)
      adjustbrightness = 255 * (maxdist-d) / maxdist
      r += adjustbrightness
      r = constrain(r, 0, 255)
      pixels[y*width + x] = color(r)
    end
  end
  update_pixels
end
