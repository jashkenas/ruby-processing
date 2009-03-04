require 'ruby-processing'

# Move the mouse across the screen and the symbol will follow.  
# Between drawing each frame of the animation, the program
# calculates the difference between the position of the 
# symbol and the cursor. If the distance is larger than
# 1 pixel, the symbol moves part of the distance (0.05) from its
# current position toward the cursor. 

class Easing < Processing::App

  def setup
    @x, @y = 0.0, 0.0
    @easing = 0.05
    smooth
    no_stroke
  end
  
  def draw
  	background 51
  	
  	dx = mouse_x - @x
  	@x += dx * @easing if dx.abs > 1
  	
  	dy = mouse_y - @y
  	@y += dy * @easing if dy.abs > 1
  	
  	ellipse @x, @y, 33, 33
  end
  
end

Easing.new :title => "Easing", :width => 200, :height => 200