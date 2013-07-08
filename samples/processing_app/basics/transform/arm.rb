# Arm. 
# 
# The angle of each segment is controlled with the mouseX and
# mouseY position. The transformations applied to the first segment
# are also applied to the second segment because they are inside
# the same push_matrix and pop_matrix group.

def setup    
  size 640, 360    
  @x, @y = width * 0.3, height * 0.5
  @angle1, @angle2 = 0.0, 0.0
  @seg_length = 100
  stroke_weight 30
  stroke 255, 160
end

def draw    
  background 0  	
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

