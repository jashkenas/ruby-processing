# Scale Shape.  
# Illustration by George Brower. 
# 
# Move the mouse left and right to zoom the SVG file.
# This shows how, unlike an imported image, the lines
# remain smooth at any size.

class ScaleShape < Processing::App

  def setup
    
    size 640, 360
    
    smooth
    
    @bot = load_shape "bot1.svg"
  end
  
  def draw
  
  	background 102
  	
  	translate width/2, height/2
  	
  	zoom = map( mouse_x, 0, width, 0.1, 4.5 )
  	scale zoom
  	
  	shape @bot, -140, -140
  end
  
end

ScaleShape.new :title => "Scale Shape"