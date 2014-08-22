#
# Histogram. 
# 
# Calculates the histogram of an image. 
# A histogram is the frequency distribution 
# of the gray levels with the number of pure black values
# displayed on the left and number of pure white values on the right. 
#

attr_reader :hist

def setup
  size(640, 360)
  
  # Load an image from the data directory
  # Load a different image by modifying the comments
  img = load_image('frontier.jpg')
  image(img, 0, 0)
  img.load_pixels
  @hist = Array.new(256, 0)
  
  # Calculate the histogram
  (0 ... img.width).each do |i|
    (0 ... img.height).each do |j|
      bright = (brightness(img.pixels[j * img.width + i]))
      hist[bright] += 1  
    end
  end
  
  # Find the largest value in the histogram using ruby array max function
  hist_max = hist.max
  
  stroke(255)
  # Draw half of the histogram (skip every second value)
  (0 ... img.width).step(2) do |i|
    # Map i (from 0..img.width) to a location in the histogram (0..255)
    which = map(i, 0, img.width, 0, 255)
    # Convert the histogram value to a location between 
    # the bottom and the top of the picture
    y = map(hist[which], 0, hist_max, img.height, 0)
    line(i, img.height, i, y)
  end
end
