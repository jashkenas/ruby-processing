require 'ruby-processing'

class Pixels2dSketch < Processing::App

  def setup
    # load the pixels array
    load_pixels
    # Two loops allow us to visit every column (x) and every row (y).
    # Loop through every pixel column
    width.times do |x|
      # Loop through every pixel row
      height.times do |y|
        # Use the formula to find the 1D location
        loc = x + y * width; # The location in the pixel array is calculated via our formula: 1D pixel location = x + y * width
        if (x % 2 == 0) # If we are an even column
          pixels[loc] = color(255)
        else # If we are an odd column
          pixels[loc] = color(0) # We use the column number (x) to determine whether the color should be black or white.
        end
      end
    end
    # update the pixels on screen
    update_pixels
  end


end

Pixels2dSketch.new :title => "Pixels 2d", :width => 200, :height => 200


