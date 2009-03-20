# Example 17-7: Boxes along a curve
require 'ruby-processing'

class BoxesAlongACurve < Processing::App

  def setup
    size 320, 320
    # The radius of a circle
    @r = 100

    # The width and height of the boxes
    @w = 40
    @h = 40
    smooth
  end

  def draw
    background 255

    # Start in the center and draw the circle
    translate width / 2, height / 2
    noFill
    stroke 0
    
    # Our curve is a circle with radius r in the center of the window.
    ellipse 0, 0, @r * 2, @r * 2

    # 10 boxes along the curve
    totalBoxes = 10

    # @we must keep track of our position along the curve
    arclength = 0

    # For every box
    totalBoxes.times do |i|
      # Each box is centered so we move half the width
      arclength +=  @w / 2.0

      # Angle in radians is the arclength divided by the radius
      theta = arclength / @r

      pushMatrix
      # Polar to cartesian coordinate conversion
      translate @r * cos(theta), @r * sin(theta)

      # @rotate the box
      rotate theta

      # Display the box
      fill 0, 100
      rectMode CENTER
      rect 0, 0, @w, @h
      popMatrix

      # Move halfway again
      arclength += @w / 2  
    end
  end

end

BoxesAlongACurve.new :title => "07 Boxes Along A Curve"