require 'ruby-processing'

# Move the mouse left and right to shift the balance. 
# The "mouseX" variable is used to control both the 
# size and color of the rectangles. 

class Mouse1d < Processing::App

  def setup
    color_mode RGB, 1.0
    rect_mode CENTER
    no_stroke
  end
  
  def draw
  	background 0
  	
  	x_dist_blocks = width/2
  	block_size = map mouse_x, 0, width, 10, x_dist_blocks-10
  	
  	left_color = -0.002 * mouse_x/2 + 0.06
  	fill 0.0, left_color + 0.4, left_color + 0.6
  	rect  width/4,    height/2, block_size*2, block_size*2
  	
  	block_size = x_dist_blocks - block_size
  	
  	right_color = 0.002 * mouse_x/2 + 0.06
  	fill 0.0, right_color + 0.2, right_color + 0.4
  	rect (width/4)*3, height/2, block_size*2, block_size*2
  end
  
end

Mouse1d.new :title => "Mouse 1d", :width => 200, :height => 200