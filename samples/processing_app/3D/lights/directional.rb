# Directional. 
# 
# Move the mouse the change the direction of the light.
# Directional light comes from one direction and is stronger 
# when hitting a surface squarely and weaker if it hits at a 
# a gentle angle. After hitting a surface, a directional lights 
# scatters in all directions. 

class Directional < Processing::App

  def setup
    
    size 640, 360, P3D
    
    no_stroke
    fill 204
    
  end
  
  def draw
  
  	background 0
  	
  	dir_x = (mouse_x / width.to_f - 0.5) * 2
  	dir_y = (mouse_y / height.to_f - 0.5) * 2
  	
  	directional_light 204, 204, 204, -dir_x, -dir_y, -1
  	
  	translate width/2 - 100, height/2
  	
  	sphere 80
  	
  	translate 200, 0
  	
  	sphere 80
  
  end
  
end

Directional.new :title => "Directional"