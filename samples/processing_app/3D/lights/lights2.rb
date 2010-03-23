# Lights 2 
# by Simon Greenwold. 
# 
# Display a box with three different kinds of lights. 

class Lights2 < Processing::App

  def setup
    
    size 640, 360, P3D
    
    no_stroke
    
  end
  
  def draw
  
  	background 0
  	
  	translate width/2, height/2
  	
  	point_light 150,  100, 0, #color
  				200, -150, 0  #position
  				
  	directional_light 0, 102, 255, #color
  					  1,   0,   0  #x-,y-,z-axis direction
  					  
  	spot_light 255, 255, 109, #color
  			     0,  40, 200, #position
  			     0,-0.5,-0.5, #direction
  			     PI/2, 2      #angle, concentration
  	
  	rotate_y map( mouse_x, 0, width, 0, PI )
  	rotate_x map( mouse_y, 0, height, 0, PI )
  	
  	box 150
  
  end
  
end

Lights2.new :title => "Lights2"