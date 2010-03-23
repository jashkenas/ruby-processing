# Texture 3. 
# 
# Load an image and draw it onto a cylinder and a quad. 
 
class Texture3 < Processing::App

  def setup
    
    size 640, 360, P3D
    
    @tube_res = 32
    @tube_x = []
    @tube_y = []
    
    @img = load_image "berlin-1.jpg"
    
    angle = 270.0 / @tube_res
    
    (0...@tube_res).each { |i|
    	@tube_x.push cos( radians( i * angle ) )
    	@tube_y.push sin( radians( i * angle ) )
    }
    
    no_stroke
    
  end
  
  def draw
  
  	background 0
  	
  	translate width/2, height/2
  	rotate_x map( mouse_y, 0, height, -PI, PI )
  	rotate_y map( mouse_x, 0, width, -PI, PI )
  	
  	begin_shape QUAD_STRIP
  	
  	texture @img
  	
  	(0...@tube_res).each { |i|
  	
  		x = @tube_x[i] * 100
  		z = @tube_y[i] * 100
  		u = @img.width / @tube_res * i
  		
  		vertex x, -100, z, u, 0
  		vertex x,  100, z, u, @img.height
  	
  	}
  	
  	end_shape
  	
  	begin_shape QUADS
  	
  		texture @img
  		
  		vertex   0, -100, 0,   0, 0
  		vertex 100, -100, 0, 100, 0
  		vertex 100,  100, 0, 100, 100
  		vertex   0,  100, 0,   0, 100
  	
  	end_shape
  
  end
  
end

Texture3.new :title => "Texture3"