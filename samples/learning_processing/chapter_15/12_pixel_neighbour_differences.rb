require 'ruby-processing'

class PixelNeighbourDifferencesSketch < Processing::App

  def setup
    @img = load_image 'sunflower.jpg'
    @destination = create_image @img.width, @img.height, RGB
  end

  def draw
    # We are going to look at both image's pixels
    @img.load_pixels()
    @destination.load_pixels()

    # Since we are looking at left neighbors
    # We skip the first column
    (1...width).each do |x|
      (0...height).each do |y|
        # Pixel location and color
        loc = x + y * @img.width
        pix = @img.pixels[loc]

        # Pixel to the left location and color
        left_loc = (x - 1) + y * @img.width
        left_pix = @img.pixels[left_loc]

        # New color is difference between pixel and left neighbor
        diff = (brightness(pix) - brightness(left_pix)).abs
        @destination.pixels[loc] = color(diff) 
      end
    end

    # We changed the pixels in @destination
    @destination.update_pixels
    # Display the @destination
    image @destination, 0, 0
  end

end

PixelNeighbourDifferencesSketch.new :title => "Pixel Neighbour Differences", :width => 200, :height => 200


