# Letter K 
# by Peter Cho. 
# 
# Move the mouse across the screen to fold the "K".

class LetterK < Processing::App

  def setup
    
    size 640, 360, P3D
    
    no_stroke
    
    @back_color = color 134, 144, 154
    @fore_color = color 235, 235, 30
    @fore_color2 = color 240, 130, 20
    
    init_particle 0.6, 0.9, width/2, height/2
    
  end
  
  def draw
  
  	background @back_color
  	
  	push_matrix
  	
  		iterate_particle 0.15 * (-@px + mouse_x), 0.15 * (-@py + (height-mouse_y))
  		
  		translate width/2, height/2
  		
  		fill @fore_color
  		
  		draw_k
  		
  		push_matrix
  		
  			translate 0, 0, 1
  			translate 0.75 * (@px-width/2), -0.75 * (@py-height/2), 0
  			translate 0.75 * (@px-width/2), -0.75 * (@py-height/2), 0
  			rotate_z atan2( -(@py-height/2), (@px-width/2) ) + PI/2
  			rotate_x PI
  			rotate_z -(atan2( -(@py-height/2), (@px-width/2) ) + PI/2)
  			
  			fill @fore_color2
  			draw_k
  		
  		pop_matrix
  		
  		translate 0.75 * (@px-width/2), -0.75 * (@py-height/2), 2
  		rotate_z atan2( -(@py-height/2), (@px-width/2) ) + PI/2
  	
  		fill @back_color
  		
  		begin_shape QUADS
  		
  			vertex -640, 0
  			vertex  640, 0
  			vertex  640, -360
  			vertex -640, -360
  		
  		end_shape
  	
  	pop_matrix
  
  end
  
  def init_particle ( mass, drag, ox, oy )
  
  	@px = ox
  	@py = oy
  	@pv2 = 0.0
  	@pvx = 0.0
  	@pvy = 0.0
  	@pa2 = 0.0
  	@pax = 0.0
  	@pay = 0.0
  	@p_mass = mass
  	@p_drag = drag
  	
  end
  
  def iterate_particle ( fkx, fky )
  
  	@pfx = fkx
  	@pfy = fky
  	@pa2 = @pfx * @pfx + @pfy * @pfy
  	return if @pa2 < 0.1e-6
  	
  	@pax = @pfx / @p_mass
  	@pay = @pfy / @p_mass
  	@pvx += @pax
  	@pvy += @pay
  	@pv2 = @pvx * @pvx + @pvy * @pvy
  	return if @pv2 < 0.1e-6
  	
  	@pvx *= 1.0 - @p_drag
  	@pvy *= 1.0 - @p_drag
  	@px += @pvx
  	@py += @pvy
  
  end
  
  def draw_k
  
	push_matrix
	
	scale 1.5
	translate -63, 71
	
	begin_shape QUADS
	
	vertex 0, 		 0, 			0
	vertex 0, 		 -142.7979, 	0
	vertex 37.1992,  -142.7979, 	0
	vertex 37.1992,  0, 			0
	
	vertex 37.1992,  -87.9990, 		0
	vertex 84.1987,  -142.7979, 	0
	vertex 130.3979, -142.7979, 	0
	vertex 37.1992,  -43.999, 		0
	
	vertex 77.5986-0.2, -86.5986-0.3, 0
	vertex 136.998,     0, 			  0
	vertex 90.7988,     0, 			  0
	vertex 52.3994-0.2, -59.999-0.3,  0
	
	end_shape
	
	pop_matrix 
  
  end
  
end

LetterK.new :title => "Letter K"