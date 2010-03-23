# Extrusion. 
# 
# Converts a flat image into spatial data points and rotates the points
# around the center.

class Extrusion < Processing::App

  def setup
    
    size 640, 360, P3D
    
    @angle = 0.0
    
    @extrude = load_image "ystone08.jpg"
    @extrude.load_pixels
    
    @values = []
    (0...@extrude.height).each { |y|
    	@values[y] = []
    	(0...@extrude.width).each { |x|
    		pxl = @extrude.get x, y
    		@values[y][x] = brightness( pxl ).to_i
    	}
    }
    
  end
  
  def draw
  
  	background 0
  	
  	@angle += 0.005
  	
  	translate width/2, 0, -128
  	rotate_y @angle
  	translate -@extrude.width/2, 100, -128
  	
  	(0...@extrude.height).each { |y|
  		(0...@extrude.width).each { |x|
  			stroke @values[y][x]
  			point x, y, -@values[y][x]
  		}
  	}
  
  end
  
end

Extrusion.new :title => "Extrusion"