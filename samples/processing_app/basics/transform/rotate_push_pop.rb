#
# Rotate Push Pop. 
# 
# The push and pop functions allow for more control over transformations.
# The push function saves the current coordinate system to the stack 
# and pop restores the prior coordinate system. 
#
                    
attr_reader :offset, :a, :num  


def setup
  size(640, 360, P3D)
  no_stroke 
  @offset = PI/24.0
  @num = 12
  @a  = 0
end 
 

def draw  
  lights  
  background(0, 0, 26)
  translate(width/2, height/2)  
  (0 ... num).each do |i|
    gray = map(i, 0, num - 1, 0, 255)
    push_matrix
    fill(gray)
    rotate_y(a + offset*i)
    rotate_x(a/2 + offset*i)
    box(200)
    pop_matrix
  end  
  @a += 0.01   
end 
