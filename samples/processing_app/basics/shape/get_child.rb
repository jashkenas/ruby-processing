# Get Child. 
# 
# SVG files can be made of many individual shapes. 
# Each of these shapes (called a "child") has its own name 
# that can be used to extract it from the "parent" file.
# This example loads a map of the United States and creates
# two new PShape objects by extracting the data from two states.

class GetChild < Processing::App

  def setup
    
    size 640, 360
    
    @usa = load_shape "usa-wikipedia.svg"
    @michigan = @usa.get_child "MI"
    @ohio = @usa.get_child "OH"
    
    smooth
    no_loop
  end
  
  def draw
  
  	background 255
  	
  	shape @usa, -600, -180
  	
  	@michigan.disable_style
  	
  	fill 0, 51, 102
  	no_stroke
  	shape @michigan, -600, -180
  	
  	@ohio.disable_style
  	
  	fill 153, 0, 0
  	shape @ohio, -600, -180
  end
  
end

GetChild.new :title => "Get Child"