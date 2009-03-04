require 'ruby-processing'

# Creating Colors (Homage to Albers). 
# 
# Creating variables for colors that may be referred to 
# in the program by their name, rather than a number. 

class Creating < Processing::App

  def setup
    
    redder = color 204, 102, 0
    yellower = color 204, 153, 0
    orangish = color 153, 51, 0
    
	# These statements are equivalent to the statements above.
	# Programmers may use the format they prefer.
	
	# redder = 0xFFCC6600
	# yellower = 0xFFCC9900
	# orangish = 0xFF993300
    
    no_stroke
	
	  fill orangish
	  rect 0, 0, 200, 200
	  
	  fill yellower
	  rect 40, 60, 120, 120
	  
	  fill redder
	  rect 60, 90, 80, 80
  end
  
end

Creating.new :title => "Creating", :width => 200, :height => 200