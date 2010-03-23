# Rotate2

class Rotate2 < Processing::App

  def setup
    
    size 640, 360, P3D
    
    @num = 12
    @colors = []
    @a = 0.0
    @offset = PI/24
    
    no_stroke
    lights
    
    1.upto(@num) { |i|
    	@colors.push color 255 * i / @num
    }
    
  end
  
  def draw
  
  	background 0, 0, 26
  	
  	translate width/2, height/2
  	
  	@a += 0.01
  	
  	@colors.each_with_index { |c, i| 
  		push_matrix
  			fill c
  			rotate_y @a + @offset * i
  			rotate_x @a/2 + @offset * i
  			
  			box 200
  		pop_matrix
  	}
  
  end
  
end

Rotate2.new :title => "Rotate2"