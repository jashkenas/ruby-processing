# Noise3D. 
# 
# Using 3D noise to create simple animated texture. 
# Here, the third dimension ('z') is treated as time. 

class Noise3D < Processing::App

  def setup
    
    size 200, 200
    frame_rate 30
    
    @increment = 0.01
    @zoff = 0.0
    @z_increment = 0.02
    
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
  		
  			bright = noise( xoff, yoff, @zoff ) * 255
  			
  			pixels[x+y*width] = color bright
  		}
  	}
  	
  	update_pixels
  	
  	@zoff += @z_increment
  
  end
  
end

Noise3D.new :title => "Noise 3 D"