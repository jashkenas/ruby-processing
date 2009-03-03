require 'ruby-processing'

# The first two parameters for the bezier function specify the 
# first point in the curve and the last two parameters specify 
# the last point. The middle parameters set the control points
# that define the shape of the curve. 

class Bezier < Processing::App

  def setup
    background 0
    stroke 255
    no_fill
    smooth
    
    (0..100).step(20) do |i|
    	bezier 90-(i/2.0), 20+i, 210, 10, 220, 150, 120-(i/8.0), 150+(i/4.0)
    end
  end
  
end

Bezier.new :title => "Bezier", :width => 200, :height => 200