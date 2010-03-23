# Shape Transform
# by Ira Greenberg.  
# 
# Illustrates the geometric relationship 
# between Cube, Pyramid, Cone and 
# Cylinder 3D primitives.
# 
# Instructions:
# Up Arrow - increases points
# Down Arrow - decreases points
# 'p' key toggles between cube/pyramid

class ShapeTransform < Processing::App

  def setup
    
    size 640, 360, P3D
    
    no_stroke
    
    @angle_inc = PI/300
    
    @pts = 4
    @angle = 0
    @radius = 99
    @cylinder_length = 95
    
    @is_pyramid = false
    
  end
  
  def draw
  
  	background 170, 95, 95
  	lights
  	fill 255, 200, 200
  	
  	translate width/2, height/2
  	rotate_x frame_count * @angle_inc
  	rotate_y frame_count * @angle_inc
  	rotate_z frame_count * @angle_inc
  	
  	vertices = []
  	
  	(0...2).each { |i|
  		@angle = 0
  		vertices[i] = []
  		0.upto(@pts) { |j|
  			pvec = PVector.new 0, 0
  			(
				pvec.x = cos(radians( @angle )) * @radius
				pvec.y = sin(radians( @angle )) * @radius
  			
  			) unless ( @is_pyramid && i == 1 )
  			
  			pvec.z = @cylinder_length
  			vertices[i][j] = pvec
  			
  			@angle += 360.0/@pts
  		}
  		@cylinder_length *= -1
  	}
  
  	begin_shape QUAD_STRIP
  	0.upto(@pts) { |j|
  		vertex vertices[0][j].x, vertices[0][j].y, vertices[0][j].z
  		vertex vertices[1][j].x, vertices[1][j].y, vertices[1][j].z
  	}
  	end_shape
  	
  	[0,1].each { |i|
  		begin_shape
  			0.upto(@pts) { |j|
  				vertex vertices[i][j].x, vertices[i][j].y, vertices[i][j].z
  			}
  		end_shape CLOSE
  	}
  	
  end
  
  def key_pressed
  
  		if key == CODED
	  		@pts += 1 if keyCode == UP && @pts < 90
  			@pts -= 1 if keyCode == DOWN && @pts > 4
  		end
  		
  		@is_pyramid = !@is_pyramid if key.eql? "p"
  		
  end
  
end

ShapeTransform.new :title => "Shape Transform"