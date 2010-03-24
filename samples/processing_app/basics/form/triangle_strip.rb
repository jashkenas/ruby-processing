require 'ruby-processing'

# TRIANGLE_STRIP Mode
# by Ira Greenberg.
#
# Generate a closed ring using vertex()
# function and beginShape(TRIANGLE_STRIP)
# mode. outerRad and innerRad variables
# control ring's outer/inner radii respectively.
# Trig functions generate ring.

class TriangleStrip < Processing::App

  def setup
    background 204
    smooth

    x = width/2
    y = height/2
    outer_radius = 80
    inner_radius = 50
    px, py, angle = 0.0, 0.0, 0.0
    number_of_points = 36
    rotation = 360.0/number_of_points

    begin_shape TRIANGLE_STRIP
    number_of_points.times do |i|
      px = x + cos(angle.radians)*outer_radius
  	  py = y + sin(angle.radians)*outer_radius
  	  angle += rotation
  	  vertex px, py

  	  px = x + cos(angle.radians)*inner_radius
  	  py = y + sin(angle.radians)*inner_radius
  	  angle += rotation
  	  vertex px, py
    end
    end_shape
  end

end

TriangleStrip.new :title => "Triangle Strip", :width => 200, :height => 200