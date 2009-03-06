require 'ruby-processing'

# Simple Radial Gradient 
# by Ira Greenberg. 
# 
# Using the convenient red(), green() 
# and blue() component functions,
# generate an array of radial gradients.

class RadialGradient < Processing::App

  def setup
    background 0
    smooth
    no_fill
    stroke_width 1.8
    
    columns = 4
    radius = (width / columns) / 2
    diameter = radius * 2
    
    (width / diameter).times do |left|
    	(height / diameter).times do |top|
    		create_gradient( 
    		  radius+left*diameter, radius+top*diameter, radius, random_color, random_color 
    		)
    	end
    end
  end
  
  def random_color
    color(rand(255), rand(255), rand(255))
  end
  
  def create_gradient( x, y, radius, c1, c2 )
  	
  	delta_r = red(c2)   - red(c1)
  	delta_g = green(c2) - green(c1)
  	delta_b = blue(c2)  - blue(c1)
  	  	
  	radius.times do |r|
  	  c = color(red(c1)   + r * (delta_r / radius),
      				  green(c1) + r * (delta_g / radius),
      				  blue(c1)  + r * (delta_b / radius))
      stroke c
      ellipse x, y, r*2, r*2
  	end
  end
  
end

RadialGradient.new :title => "Radial Gradient", :width => 200, :height => 200