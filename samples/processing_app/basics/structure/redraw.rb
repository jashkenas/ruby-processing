# Redraw. 
# 
# The redraw() function makes draw() execute once.  
# In this example, draw() is executed once every time 
# the mouse is clicked. 

class Redraw < Processing::App

  def setup
    
    size 200, 200
    
    @y = 100
    
    stroke 255
    no_loop
  end
  
  def draw
  
  	background 0
  	
  	@y = @y - 1
  	@y = height if @y < 0
  	
  	line 0, @y, width, @y
  end
  
  def mouse_pressed
  	
  	redraw
  end
  
end

Redraw.new :title => "Redraw"