# Recursion. 
# 
# A demonstration of recursion, which means functions call themselves. 
# Notice how the drawCircle() function calls itself at the end of its block. 
# It continues to do this until the variable "level" is equal to 1.

class Recursion1 < Processing::App

  def setup
    
    size 200, 200
    
    no_stroke
    smooth
    no_loop
  end
  
  def draw
  
  	draw_circle 126, 170, 6
  end
  
  def draw_circle ( x, radius, level )
  
  	tt = 126 * level / 4.0
  	
  	fill tt
  	
  	ellipse x, 100, radius*2, radius*2
  	
  	if level > 1
  		
  		level = level - 1
  		
  		draw_circle x - radius/2, radius/2, level
  		draw_circle x + radius/2, radius/2, level
  	end
  end
  
end

Recursion1.new :title => "Recursion1"