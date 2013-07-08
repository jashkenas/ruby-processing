# Translate. 
# 
# The translate() function allows objects to be moved
# to any location within the window. The first parameter
# sets the x-axis offset and the second parameter sets the
# y-axis offset. 


def setup    
  size 640, 360
  no_stroke
  frame_rate 30    
  @x, @y = 0.0, 0.0
  @size = 80.0
end

def draw    
  background 102  	
  @x += 0.8  	
  @x = -@size if @x > width + @size  	
  translate @x, height/2 - @size/2  	
  fill 255
  rect -@size/2, -@size/2, @size, @size  	
  translate @x, @size  	
  fill 0
  rect -@size/2, -@size/2, @size, @size
end
