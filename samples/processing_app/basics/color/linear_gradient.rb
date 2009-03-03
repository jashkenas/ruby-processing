require 'ruby-processing'

# Simple Linear Gradient 
# by Ira Greenberg. 
# 
# Using the convenient red(), green() 
# and blue() component functions,
# generate some linear gradients.

class LinearGradient < Processing::App

  def setup
    b1 = color 190
    b2 = color 20
    set_gradient 0, 0, width.to_f, height.to_f, b1, b2, :y_axis
    
    c1 = color 255, 120, 0 
  	c2 = color 10, 45, 255 
  	c3 = color 10, 255, 15 
  	c4 = color 125, 2, 140 
  	c5 = color 255, 255, 0 
  	c6 = color 25, 255, 200 
  	set_gradient 25, 25, 75, 75, c1, c2, :y_axis
  	set_gradient 100, 25, 75, 75, c3, c4, :x_axis
  	set_gradient 25, 100, 75, 75, c2, c5, :x_axis
  	set_gradient 100, 100, 75, 75, c4, c6, :y_axis
  end
  
  def set_gradient( x, y, w, h, c1, c2, axis )
  	deltaR = red( c2 ) - red( c1 )
  	deltaG = green( c2 ) - green( c1 )
  	deltaB = blue( c2 ) - blue( c1 )
  	
	x.upto( x+w ) do |i|
		y.upto( y+w ) do |j|
			c = color( (red(c1)+(j-y)*(deltaR/h)),
					  (green(c1)+(j-y)*(deltaG/h)),
					  (blue(c1)+(j-y)*(deltaB/h)) )
			case axis
			when :y_axis
				set i, j, c
			when :x_axis
				set j, i, c
			end
		end
	end
  end
  
end

LinearGradient.new :title => "Linear Gradient", :width => 200, :height => 200