require 'ruby-processing'

class BrightnessThresholdWithFilterSketch < Processing::App

  def setup
    @img = load_image 'sunflower.jpg'
  end

  def draw
    # Draw the image
    image @img, 0, 0
    # Filter the window with a threshold effect
    # 0.5 means threshold is 50% brightness
    filter THRESHOLD, 0.5
  end

end

BrightnessThresholdWithFilterSketch.new :title => "Brightness Threshold With Filter", :width => 200, :height => 200

