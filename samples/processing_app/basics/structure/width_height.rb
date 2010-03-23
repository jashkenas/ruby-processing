# Width and Height. 
# 
# The 'width' and 'height' variables contain the width and height 
# of the display window as defined in the size() function. 

class WidthHeight < Processing::App

  def setup
    
    size 200, 200 
    
	background 127 
	no_stroke
	
	(0...height).step( 20 ) do |i|
		fill 0 
		rect 0, i, width, 10 
		fill 255 
		rect i, 0, 10, height 
	end
  end
  
  def draw
  
  end
  
end

WidthHeight.new :title => "Width Height"