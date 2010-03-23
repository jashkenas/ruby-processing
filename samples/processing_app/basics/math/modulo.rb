# Modulo. 
# 
# The modulo operator (%) returns the remainder of a number 
# divided by another. As in this example, it is often used 
# to keep numerical values within a set range. 

class Modulo < Processing::App

  def setup
    
    size 200, 200
    
    @c = 0.0
    @num = 20
    
    fill 255
    frame_rate 30
    
  end
  
  def draw
  
  	background 0
  	
  	@c += 0.1
  	
  	(1...(height/@num)).each { |i|
  	
  		x = (@c %i ) * i * i
  		stroke 102
  		
  		line 0, i*@num, x, i*@num
  		
  		no_stroke
  		
  		rect x, i*@num-@num/2, 8, @num
  	}
  
  end
  
end

Modulo.new :title => "Modulo"