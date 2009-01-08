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
        # The location in the pixel array is calculated via our formula: 1D pixel location = x + y * width
        loc = x + y * width
        # We use the even-or-odd-ness of the column number (x) to determine whether the color should be black or white.
        pixels[loc] = (x % 2 == 0) ? color(255) : color(0)
      end
    end
    # update the pixels on screen
    update_pixels
  end


end

Pixels2dSketch.new :title => "Pixels 2d", :width => 200, :height => 200


