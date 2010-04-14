# Interactive Toroid
# by Ira Greenberg. 
# 
# Illustrates the geometric relationship between Toroid, Sphere, and Helix
# 3D primitives, as well as lathing principal.
# 
# Instructions: 
# 	UP arrow key ____ pts++ 
# 	DOWN arrow key __ pts-- 
# 	LEFT arrow key __ segments-- 
# 	RIGHT arrow key _ segments++ 
# 	'a' key _________ toroid radius-- 
# 	's' key _________ toroid radius++ 
# 	'z' key _________ initial polygon radius-- 
# 	'x' key _________ initial polygon radius++ 
# 	'w' key _________ toggle wireframe/solid shading 
# 	'h' key _________ toggle sphere/helix 


class Toroid < Processing::App

  def setup
    
    size 640, 360, P3D
    
	@pts = 40
	@angle = 0.0
	@radius = 60.0
	@segments = 60.0
	@lathe_angle = 0.0
	@lathe_radius = 100.0
	@is_wireframe = false
	@is_helix = false
	@helix_offset = 5.0
    
  end
  
  def draw
  	
  	background 50, 64, 42
  	
  	lights
  	
  	if @is_wireframe
  		stroke 255, 255, 150
  		no_fill
  	else
  		no_stroke
  		fill 150, 195, 125
  	end
  	
  	translate width/2, height/2, -100
  	
  	rotate_x frame_count * PI / 150
  	rotate_y frame_count * PI / 170
  	rotate_z frame_count * PI / 90
  	
  	vertices = []
  	vertices2 = []
  	
  	0.upto(@pts) { |i|
  	
  		vertices2[i] = PVector.new
  		vertices[i] = PVector.new
  		
  		vertices[i].x = @lathe_radius + sin( radians( @angle ) ) * @radius
  		
  		if @is_helix
	  		vertices[i].z = cos( radians( @angle ) ) * @radius - (@helix_offset * @segments) / 2
	  	else
	  		vertices[i].z = cos( radians( @angle ) ) * @radius
	  	end
	  	
	  	@angle += 360.0 / @pts
  	}
  	
  	@lathe_angle = 0
  	
  	0.upto(@segments) { |i|
  		begin_shape QUAD_STRIP
  			(0..@pts).each { |j|
  				vertex_for_pvector vertices2[j] if i > 0
  				
  				vertices2[j].x = cos( radians( @lathe_angle ) ) * vertices[j].x
  				vertices2[j].y = sin( radians( @lathe_angle )
						     ) * vertices[j].x
  				vertices2[j].z = vertices[j].z
  				
  				vertices[j].z += @helix_offset if @is_helix
  				
  				vertex_for_pvector vertices2[j]
  			}
  			
  			@lathe_angle += (@is_helix ? 720 : 360) / @segments
  		end_shape
  	}
  	
  end
  
  def vertex_for_pvector ( pvec )
  	vertex( pvec.x, pvec.y, pvec.z )
  end
  
  def key_pressed
  
  	if key == CODED
  	
  		@pts += 1 if keyCode == UP && @pts < 40
  		@pts -= 1 if keyCode == DOWN && @pts > 3
  		
  		@segments += 1 if keyCode == RIGHT && @segments < 80
  		@segments -= 1 if keyCode == LEFT && @segments > 3
  
  	end
  	
  	@lathe_radius += 1 if key.eql? "s"
  	@lathe_radius -= 1 if key.eql? "a" #&& @lathe_radius > 0
  	
  	@radius += 1 if key.eql? "x"
  	@radius -= 1 if key.eql? "z" && @radius > 10
  	
  	@is_wireframe = !@is_wireframe if key.eql? "w"
  	
  	@is_helix = !@is_helix if key.eql? "h"
  
  end
  
end

Toroid.new :title => "Toroid"