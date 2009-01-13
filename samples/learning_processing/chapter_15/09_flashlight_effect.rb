require 'ruby-processing'

class FlashlightEffectSketch < Processing::App

  def setup
    @image = load_image 'sunflower.jpg'
    # Let's grab the red, green and blue component of each pixel of the image to start with.
    @image_pixels = @image.pixels.map {|p| [red(p), green(p), blue(p)]}
  end

  def draw
    load_pixels # Load the pixels array
    # Two loops allow us to visit every column (x) and every row (y).
    # Loop through every pixel column
    width.times do |x|
      # Loop through every pixel row
      height.times do |y|
        # Use the formula to find the 1D location
        loc = x + y * width # The location in the pixel array is calculated via our formula: 1D pixel location = x + y * width

        # Calculate an amount to change brightness
        # based on proximity to the mouse
        distance = dist(x, y, mouseX, mouseY)

        # The closer the pixel is to the mouse, the lower the value of "distance" 
        # We want closer pixels to be brighter, however, so we invert the value with the formula: adjustment = (50-distance)/50 
        # Pixels with a distance of 50 (or greater) have a brightness of 0.0 (or negative which is equivalent to 0 here)
        # Pixels with a distance of 0 have a brightness of 1.0.
        adjustment = (50 - distance) / 50

        # Set the display pixel to the image pixel
        pixels[loc] = color(*@image_pixels[loc].map {|rgb| rgb * adjustment })
      end
    end
    update_pixels
  end

end

FlashlightEffectSketch.new :title => "Flashlight Effect", :width => 200, :height => 200


