# Graphing 2D Equations
# by Daniel Shiffman. 
# 
# Graphics the following equation: 
# sin(n*cos(r) + 5*theta) 
# where n is a function of horizontal mouse location.

class Graphing2DEquation < Processing::App

  def setup
    
    size 200, 200
    frame_rate 30
    
  end
  
  def draw
  
  	load_pixels
  	
  	n = mouse_x * 10.0 / width
  	w = 16.0
  	h = 16.0
  	dx = w / width
  	dy = h / height
  	x = -w / 2
  	
  	(0...width).each { |i|
  		
  		y = -h / 2
  		
  		(0...height).each { |j|
  			
  			r = sqrt( x*x + y*y )
  			theta = atan2 y, x
  			
  			val = sin( n*cos(r) + 5 * theta)
  			
  			pixels[i+j*width] = color( map( val, -1, 1, 0, 255) )
  			
  			y += dy
  		}
  		
  		x += dx
  	}
  
  	update_pixels
  	
  end
  
end

Graphing2DEquation.new :title => "Graphing 2 D Equation"