# Distance 2D. 
# 
# Move the mouse across the image to obscure and reveal the matrix.  
# Measures the distance from the mouse to each square and sets the
# size proportionally. 

class Distance2 < Processing::App

  def setup
    
    size 200, 200
    
    smooth
    no_stroke
    @max_distance = dist 0, 0, width, height
    
  end
  
  def draw
  	
  	background 51
  	
  	(0..width).step( 20 ) { |i|
  	
  		(0..height).step( 20 ) { |j|
  		
  			size = dist mouse_x, mouse_y, i, j
  			size = size / @max_distance * 66
  			
  			ellipse i, j, size, size
  		}
  	}
  	
  end
  
end

Distance2.new :title => "Distance2"