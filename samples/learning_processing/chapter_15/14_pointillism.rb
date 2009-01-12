require 'ruby-processing'

class PointillismSketch < Processing::App

  def setup
    @pointillize = 16
    @img = load_image 'sunflower.jpg'
    background 255
    smooth
  end

  def draw
    # Pick a random point
    x = rand @img.width
    y = rand @img.height
    loc = x + y * @img.width

    # Look up the RGB color in the source image
    load_pixels
    r = red @img.pixels[loc]
    g = green @img.pixels[loc]
    b = blue @img.pixels[loc]
    no_stroke

    # Draw an ellipse at that location with that color
    fill r, g, b, 100
    # Back to shapes! Instead of setting a pixel, we use the color from a pixel to draw a circle.
    ellipse x, y, @pointillize, @pointillize
  end

end

PointillismSketch.new :title => "Pointillism", :width => 200, :height => 200


