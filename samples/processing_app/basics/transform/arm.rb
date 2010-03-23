# Arm. 
# 
# The angle of each segment is controlled with the mouseX and
# mouseY position. The transformations applied to the first segment
# are also applied to the second segment because they are inside
# the same push_matrix and pop_matrix group.

class Arm < Processing::App

  def setup
    
    size 200, 200
    
    @x, @y = 50, 100
    @angle1, @angle2 = 0.0, 0.0
    @seg_length = 50
    
    smooth
    stroke_weight 20
    stroke 0, 100
  end
  
  def draw
  
  	background 226
  	
  	@angle1 = (mouse_x / width.to_f - 0.5) * -PI
  	@angle2 = (mouse_y / height.to_f - 0.5) * PI
  	
  	push_matrix
  	
  		segment @x, @y, @angle1
  		segment @seg_length, 0, @angle2
  	pop_matrix
  end
  
  def segment ( x, y, a )
  	
  	translate x, y
  	rotate a
  	
  	line 0, 0, @seg_length, 0 
  end
  
end

Arm.new :title => "Arm"