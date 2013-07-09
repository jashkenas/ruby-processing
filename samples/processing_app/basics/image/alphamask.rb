# Loads a "mask" for an image to specify the transparency 
# in different parts of the image. The two images are blended
# together using the mask() method of PImage. 


def setup
  size 640, 360
  @image = load_image "test.jpg"
  @image_mask = load_image "mask.jpg"
  @image.mask @image_mask
end

def draw
  background((mouse_x + mouse_y) / 1.5)
  image @image, width / 2, height / 2
  image @image, mouse_x - @image.width, mouse_y - @image.height
end
