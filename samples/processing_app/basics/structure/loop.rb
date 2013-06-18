# Loop. 
# 
# The loop() function causes draw() to execute
# continuously. If noLoop is called in setup()
# the draw() is only executed once. In this example
# click the mouse to execute loop(), which will
# cause the draw() the execute continuously. 


def setup    
  size 200, 200
  stroke 255    
  no_loop # stops draw loop    
  @y = 100
end

def draw  
  background 0  	
  line 0, @y, width, @y  	
  @y = @y - 1  	
  @y = height if @y < 0
end

def mouse_pressed  
  loop # re starts draw loop 
  end
