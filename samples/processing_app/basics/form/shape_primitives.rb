require 'ruby-processing'

# The basic shape primitive functions are triangle, rect, 
# quad, and ellipse. Squares are made with rect and circles 
# are made with ellipse. Each of these functions requires a number
# of parameters to determine the shape's position and size.


class ShapePrimitives < Processing::App

  def setup
	smooth   
	background 0 
	no_stroke
	fill 226 
	triangle 10, 10, 10, 200, 45, 200 
	rect 45, 45, 35, 35 
	quad 105, 10, 120, 10, 120, 200, 80, 200 
	ellipse 140, 80, 40, 40 
	triangle 160, 10, 195, 200, 160, 200  
  end
  
end

ShapePrimitives.new :title => "Shape Primitives", :width => 200, :height => 200