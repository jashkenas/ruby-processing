# Recursion2

class Recursion2 < Processing::App

  def setup
    
    size 200, 200
    
    no_stroke
    smooth
    
    draw_circle 100, 100, 80, 8
  end
  
  def draw_circle ( x, y, radius, level )
  
  	tt = 126 * level / 6.0
  	fill tt, 153
  	
  	ellipse x, y, radius*2, radius*2
  	
  	if level > 1
  	
  		level = level - 1
  		num = random( 2, 6 ).to_i
  		
  		0.upto( num-1 ) do |i|
  			
  			a = random 0, TWO_PI
  			nx = x + cos( a ) * 6.0 * level
  			ny = y + sin( a ) * 6.0 * level
  			draw_circle nx, ny, radius/2, level
  		end
  	end
  end
  
end

Recursion2.new :title => "Recursion2"