require 'ruby-processing'

class ImagePixelsSketch < Processing::App

  def setup
    @image = load_image 'sunflower.jpg'
  end

  def draw
    # load the pixels array
    load_pixels
    # Two loops allow us to visit every column (x) and every row (y).
    # Loop through every pixel column
    width.times do |x|
      # Loop through every pixel row
      height.times do |y|
        # Use the formula to find the 1D location
        loc = x + y * width # The location in the pixel array is calculated via our formula: 1D pixel location = x + y * width

        # The functions red, green, and blue pull out the three color components from a pixel.
        r = red(@image.pixels[loc]) 
        g = green(@image.pixels[loc])
        b = blue(@image.pixels[loc])

        # Image Processing would go here
        # If we were to change the RGB values, we would do it here, before setting the pixel in the display window.

        # Set the display pixel to the image pixel
        pixels[loc] = color(r,g,b)
      end
    end
    # update the pixels on screen
    update_pixels
  end

end

ImagePixelsSketch.new :title => "Image Pixels", :width => 200, :height => 200


