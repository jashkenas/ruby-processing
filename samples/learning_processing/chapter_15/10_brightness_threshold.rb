require 'ruby-processing'

class BrightnessThresholdSketch < Processing::App

  def setup
    @source = load_image 'sunflower.jpg'
    @destination = create_image @source.width, @source.height, RGB
  end

  def draw
    threshold = 127
    # We are going to look at both image's pixels
    @source.load_pixels
    @destination.load_pixels

    @source.width.times do |x|
      @source.height.times do |y|
        loc = x + y*@source.width;
        # Test the brightness against the threshold
        @destination.pixels[loc] = (brightness(@source.pixels[loc]) > threshold) ? color(255) : color(0)
      end
    end

    # We changed the pixels in @destination
    @destination.update_pixels
    # Display the @destination
    image @destination, 0, 0
  end

end

BrightnessThresholdSketch.new :title => "Brightness Threshold", :width => 200, :height => 200

