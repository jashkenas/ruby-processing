require 'ruby-processing'

# Creating Colors (Homage to Albers). 
# 
# Creating variables for colors that may be referred to 
# in the program by their name, rather than a number. 

class Creating < Processing::App

  def setup
    
    inside = color 204, 102, 0
    middle = color 204, 153, 0
    outside = color 153, 51, 0
    
	# These statements are equivalent to the statements above.
	# Programmers may use the format they prefer.
	
	# inside = 0xFFCC6600
	# middle = 0xFFCC9900
	# outside = 0xFF993300
    
    no_stroke
	
	fill outside
	rect 0, 0, 200, 200
	
	fill middle
	rect 40, 60, 120, 120
	
	fill inside
	rect 60, 90, 80, 80
  end
  
end

Creating.new :title => "Creating", :width => 200, :height => 200