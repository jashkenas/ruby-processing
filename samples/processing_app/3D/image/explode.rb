# Explode 
# by Daniel Shiffman. 
# 
# Mouse horizontal location controls breaking apart of image and 
# Maps pixels from a 2D image into 3D space. Pixel brightness controls 
# translation along z axis. 

class Explode < Processing::App

  def setup
    
    size 640, 360, P3D
    
    @cell_size = 2
    @img = load_image "eames.jpg"
    @columns = @img.width / @cell_size
    @rows = @img.height / @cell_size
    
  end
  
  def draw
  
  	background 0
  	
  	(0...@columns).each { |i|
  		
  		(0...@rows).each { |j|
  		
  			x = i * @cell_size + @cell_size / 2
  			y = j * @cell_size + @cell_size / 2
  			
  			loc = x + y * @img.width
  			
  			c = @img.pixels[loc]
  			
  			z = (mouse_x / width.to_f) * brightness( @img.pixels[loc] ) - 20
  			
  			push_matrix
  			
  			translate x + 200, y + 100, z
  			
  			fill c, 204
  			no_stroke
  			rect_mode CENTER
  			
  			rect 0, 0, @cell_size, @cell_size
  			
  			pop_matrix
  		}
  	}
  
  end
  
end

Explode.new :title => "Explode"