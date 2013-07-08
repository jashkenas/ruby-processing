# Noise3D. 
# 
# Using 3D noise to create simple animated texture. 
# Here, the third dimension ('z') is treated as time.
attr_reader :increment, :z_increment

def setup    
  size 640, 360
  frame_rate 30    
  @increment = 0.01
  @zoff = 0.0
  @z_increment = 0.02    
end

def draw    
  background 0  	
  load_pixels  	
  xoff = 0.0  	
  (0...width).each do |x|  	    
    xoff += increment
    yoff = 0.0  		
    (0...height).each do |y|  		    
      yoff += increment  			
      bright = noise( xoff, yoff, @zoff ) * 255  			
      pixels[x + y * width] = color(bright, bright, bright)
    end
  end  	
  update_pixels  	
  @zoff += z_increment  	
end
