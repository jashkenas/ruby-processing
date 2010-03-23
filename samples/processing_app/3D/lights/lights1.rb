# Lights 1. 
# 
# Uses the default lights to show a simple box. The lights() function
# is used to turn on the default lighting.

class Lights1 < Processing::App

  def setup
    
    size 640, 360, P3D
    
    @spin = 0.0
    
    no_stroke
    
  end
  
  def draw
  
  	background 51
  	lights
  	
  	@spin += 0.01
  	
  	push_matrix
  	
  	translate width/2, height/2
  	rotate_x PI/9
  	rotate_y PI/5 + @spin
  	
  	box 150
  	
  	pop_matrix
  
  end
  
end

Lights1.new :title => "Lights1"