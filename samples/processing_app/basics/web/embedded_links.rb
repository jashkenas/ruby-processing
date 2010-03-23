# Loading URLs. 
# 
# Click on the left button to open a different URL in the same window (Only
# works online). Click on the right button to open a URL in a new browser window.  

class EmbeddedLinks < Processing::App

  def setup
    
    size 200, 200
    
  end
  
  def draw
  
  	background 204
  	
  	no_fill
  	fill 255 if @over_left_button
  	
  	rect 20, 60, 75, 75
  	rect 50, 90, 15, 15
  	
  	no_fill
  	fill 255 if @over_right_button
  	
  	rect 105,  60,  75,  75
  	line 135, 105, 155,  85
  	line 140,  85, 155,  85
  	line 155,  85, 155, 100
  
  end
  
  def mouse_pressed
  	link "http://www.processing.org"         if @over_left_button
  	link "http://www.processing.org", "_new" if @over_right_button
  end
  
  def mouse_moved 
  	check_buttons 
  end
  
  def mouse_dragged
  	check_buttons
  end
  
  def check_buttons
  	@over_left_button  = inside? mouse_x, mouse_y,  20,  95, 60, 135
  	@over_right_button = inside? mouse_x, mouse_y, 105, 180, 60, 135
  end
  
  def inside? ( x, y, l, r, t, b )
  	return x > l && x < r && y > t && y < b
  end
  
end

EmbeddedLinks.new :title => "Embedded Links"