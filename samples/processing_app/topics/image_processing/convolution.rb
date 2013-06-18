#*
# Convolution
# by Daniel Shiffman.  
# 
# Applies a convolution matrix to a portion of an image. Move mouse to 
# apply filter to different parts of the image. 
#

attr_reader :img

# It's possible to convolve the image with many different 
# matrices to produce different effects. This is a high-pass 
# filter it accentuates the edges.

MATRIX = [ [ -1, -1, -1 ], [ -1,  9, -1 ], [ -1, -1, -1 ] ]
W = 120

def setup
  size(640, 360)
  @img = load_image("moon-wide.jpg") 
end

def draw
  # We're only going to process a portion of the image
  # so let's set the whole image as the background first
  image(img, 0, 0)
  
  # Calculate the small rectangle we will process
  xstart = constrain(mouse_x - W/2, 0, img.width)
  ystart = constrain(mouse_y - W/2, 0, img.height)
  xend = constrain(mouse_x + W/2, 0, img.width)
  yend = constrain(mouse_y + W/2, 0, img.height)

  load_pixels
  # Begin our loop for every pixel in the smaller image
  (xstart ... xend).each do |x| 
    (ystart ... yend).each do |y| 
      loc = x + y * img.width
      pixels[loc] = convolution(x, y, MATRIX, MATRIX.length, img)
    end
  end
  update_pixels
end

def convolution(x, y, matrix, matrixsize, img)

  rtotal = 0.0
  gtotal = 0.0
  btotal = 0.0
  offset = matrixsize / 2
  (0 ... matrixsize).each do |i|
     (0 ... matrixsize).each do |j|
      # What pixel are we testing
      xloc = x + i - offset
      yloc = y + j - offset
      loc = xloc + img.width * yloc
      # Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc, 0, img.pixels.length - 1)
      # Calculate the convolution
      rtotal += (red(img.pixels[loc]) * matrix[i][j])
      gtotal += (green(img.pixels[loc]) * matrix[i][j])
      btotal += (blue(img.pixels[loc]) * matrix[i][j])
    end
  end
  # Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255)
  gtotal = constrain(gtotal, 0, 255)
  btotal = constrain(btotal, 0, 255)
  # Return the resulting color
  return color(rtotal, gtotal, btotal)
end

