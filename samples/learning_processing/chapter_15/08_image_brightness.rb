require 'ruby-processing'

class ImageBrightnessSketch < Processing::App

  def setup
    @image = load_image 'sunflower.jpg'
  end

  def draw
    # We calculate a multiplier ranging from 0.0 to 8.0 based on mouseX position. 
    # That multiplier changes the RGB value of each pixel.      
    adjust_brightness = (mouseX.to_f / width) * 8.0 
    # load the pixels array
    load_pixels
    # Two loops allow us to visit every column (x) and every row (y).
    # Loop through every pixel column
    width.times do |x|
      # Loop through every pixel row
      height.times do |y|
        # Use the formula to find the 1D location
        # The location in the pixel array is calculated via our formula: 1D pixel location = x + y * width
        loc = x + y * width

        # The functions red, green, and blue pull out the three color components from a pixel.
        r = red(@image.pixels[loc]) 
        g = green(@image.pixels[loc])
        b = blue(@image.pixels[loc])

        r *= adjust_brightness
        g *= adjust_brightness
        b *= adjust_brightness

        # The RGB values are constrained between 0 and 255 before being set as a new color.      
        r = constrain(r, 0, 255) 
        g = constrain(g, 0, 255)
        b = constrain(b, 0, 255)

        # Make a new color and set pixel in the window
        pixels[loc] = color(r, g, b)
      end
    end
    # update the pixels on screen
    update_pixels
  end

end

ImageBrightnessSketch.new :title => "Image Brightness", :width => 200, :height => 200


