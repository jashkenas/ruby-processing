require 'ruby-processing'

# Click on the box and drag it across the screen. 

class MouseFunctions < Processing::App

  def setup
    @block = {"x" => width/2.0, "y" => height/2.0}
    @block_diff = {"x" => 0.0, "y" => 0.0}
    @locked = false
    @over_block = false
    @block_width = 20
    
    rect_mode RADIUS
  end
  
  def draw
  	background 0
  	
  	fill 153
  	
  	if (mouse_x > @block["x"]-@block_width &&	# Test if the cursor is over the box 
	      mouse_x < @block["x"]+@block_width &&
	      mouse_y > @block["y"]-@block_width &&
	      mouse_y < @block["y"]+@block_width )
  		
  		@over_block = true
  		
  		stroke 255
  		
  		fill 255 if block_locked?
  	else
  		@over_block = false
  		stroke 153
  	end
  	
  	# Draw the box
  	rect @block["x"], @block["y"], @block_width, @block_width
  end
  
  def block_locked?
  	@block_locked
  end
  
  def over_block?
  	@over_block
  end
  
  def mouse_pressed
  	if over_block?
  		@block_locked = true
  		fill 255
  	else
  		@block_locked = false
  	end
  	@block_diff["x"] = mouse_x - @block["x"]
  	@block_diff["y"] = mouse_y - @block["y"]
  end
  
  def mouse_dragged
  	if block_locked?
  		@block["x"] = mouse_x - @block_diff["x"]
  		@block["y"] = mouse_y - @block_diff["y"]
  	end
  end
  
  def mouse_released
  	@block_locked = false
  end
  
end

MouseFunctions.new :title => "Mouse Functions", :width => 200, :height => 200