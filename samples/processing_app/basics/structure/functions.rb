# Functions. 
# 
# The drawTarget() function makes it easy to draw many distinct targets. 
# Each call to drawTarget() specifies the position, size, and number of 
# rings for each target. 

class Functions < Processing::App

  def setup
    
    size 200, 200
    
    no_stroke
    smooth
    no_loop
  end
  
  def draw
    
    background 51
    
    draw_target  68,  34, 200, 10
    draw_target 152,  16, 100,  3
    draw_target 100, 144,  80,  5
  end
  
  def draw_target ( x, y, size, num )
  
  	greys = 255 / num
  	steps = size / num
  	
  	(0...num).each do |i|
  		
  		fill greys * i
  		ellipse x, y, size - i*steps, size - i*steps
  	end
  end
  
end

Functions.new :title => "Functions"