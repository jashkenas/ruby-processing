# Load and Display a Shape. 
# Illustration by George Brower. 
# 
# The loadShape() command is used to read simple SVG (Scalable Vector Graphics)
# files into a Processing sketch. This library was specifically tested under
# SVG files created from Adobe Illustrator. For now, we can't guarantee that 
# it'll work for SVGs created with anything else. 

class LoadDisplayShape < Processing::App

  def setup
    
    size 640, 360
    
    smooth
    
    @bot = load_shape "bot1.svg"
    
    no_loop
  end
  
  def draw
  
  	background 102
  	
  	shape @bot, 110, 90, 100, 100
  	
  	shape @bot, 280, 40
  end
  
end

LoadDisplayShape.new :title => "Load Display Shape"