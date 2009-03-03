require 'ruby-processing'

# Move the mouse across the screen to move the circle. 
# The program constrains the circle to its box. 

class Constrain < Processing::App

  def setup
    no_stroke
    smooth
    ellipse_mode RADIUS
    
    @mx = 0.0
    @my = 0.0
    @easing = 0.05
    @ellipse_size = 25.0
    @box_size = 30
  end
  
  def draw
  	background 51
  	
  	if (mouse_x - @mx).abs > 0.1
	  	@mx += (mouse_x - @mx) * @easing
  	end
  	
  	if (mouse_y - @my).abs > 0.1
	  	@my += (mouse_y - @my) * @easing
  	end
  	
  	distance = @ellipse_size * 2
  	@mx = constrain @mx, (@box_size + distance), (width  - @box_size - distance)
  	@my = constrain @my, (@box_size + distance), (height - @box_size - distance)
  	
  	fill 76
  	rect @box_size + @ellipse_size, @box_size + @ellipse_size, 
  		 @box_size * 3, @box_size * 3
  		 
  	fill 255
  	ellipse @mx, @my, @ellipse_size, @ellipse_size 
  end
  
end

Constrain.new :title => "Constrain", :width => 200, :height => 200