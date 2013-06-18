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
  img = loadImage("frontier.jpg")
  image(img, 0, 0)
  @hist = Array.new(256, 0)
  
  # Calculate the histogram
  (0 ... img.width).each do |i|
    (0 ... img.height).each do |j|
      bright = (brightness(get(i, j))).to_i
      hist[bright] += 1  
    end
  end
  
  # Find the largest value in the histogram using processings max function
  # that's why we use to java cinversion
  histMax = max(hist.to_java Java::int)
  
  stroke(255)
  # Draw half of the histogram (skip every second value)
  (0 ... img.width).step(2) do |i|
    # Map i (from 0..img.width) to a location in the histogram (0..255)
    which = (map(i, 0, img.width, 0, 255)).to_i
    # Convert the histogram value to a location between 
    # the bottom and the top of the picture
    y = (map(hist[which], 0, histMax, img.height, 0)).to_i
    line(i, img.height, i, y)
  end
end
