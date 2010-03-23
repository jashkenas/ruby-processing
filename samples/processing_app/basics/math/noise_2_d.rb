# Noise2D 
# by Daniel Shiffman.  
# 
# Using 2D noise to create simple texture. 

class Noise2D < Processing::App

  def setup
    
    size 200, 200
    
    @increment = 0.02
    
    no_loop
    
  end
  
  def draw
  
  	background 0
  	
  	load_pixels
  	
  	xoff = 0.0
  	
  	(0...width).each { |x|
  	
  		xoff += @increment
  		yoff = 0.0
  		
  		(0...height).each { |y|
  		
  			yoff += @increment
  			
  			bright = noise( xoff, yoff) * 255
  			
  			pixels[x+y*width] = color bright
  		}
  	}
  	
  	update_pixels
  
  end
  
end

Noise2D.new :title => "Noise 2 D"