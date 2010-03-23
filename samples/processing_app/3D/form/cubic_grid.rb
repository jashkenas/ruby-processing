# Cubic Grid 
# by Ira Greenberg. 
# 
# 3D translucent colored grid uses nested pushMatrix()
# and popMatrix() functions. 

class CubicGrid < Processing::App

  def setup
    size 640, 360, P3D
    no_stroke
    
    @box_size = 40
    @margin = @box_size * 2
    @depth = 400
  end
  
  def draw
  	background 255
  	
  	translate width/2, height/2, -@depth
  	rotate_x frame_count * 0.01
  	rotate_y frame_count * 0.01
  	
  	((-@depth/2 + @margin)..(@depth/2 - @margin)).step( @box_size ) { |i|
  		push_matrix
  		
  		((-height + @margin)..(height - @margin)).step( @box_size ) { |j|
  			push_matrix
  			
  			((-width + @margin)..(width - @margin)).step( @box_size ) { |k|
  				box_fill = color i.abs, j.abs, k.abs, 50
  				push_matrix
  				
  				translate k, j, i
  				fill box_fill
  				box @box_size
  				
  				pop_matrix
  			}
  			
  			pop_matrix
  		}
  		
  		pop_matrix
  	}
  end
  
end

CubicGrid.new :title => "Cubic Grid"