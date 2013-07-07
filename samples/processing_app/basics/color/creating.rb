# Creating Colors (Homage to Albers). 
# 
# Creating variables for colors that may be referred to 
# in the program by their name, rather than a number. 


def setup
  size 640, 360
  redder = color 204, 102, 0
  yellower = color 204, 153, 0
  orangish = color 153, 51, 0
  
	# These statements are equivalent to the statements above.
	# Programmers may use the format they prefer.
	
	# redder = color '#CC6600'
	# yellower = color '#CC9900'
	# orangish = color '#993300'
	
	# or alternatively
	
	# redder = color 0xFFCC6600
	# yellower = color 0xFFCC9900
	# orangish = color 0xFF993300
	
	no_stroke
	background 51, 0, 0
	push_matrix
  translate 80, 80
  fill orangish
  rect 0, 0, 200, 200
  fill yellower
  rect 40, 60, 120, 120
  fill redder
  rect 60, 90, 80, 80
  pop_matrix
  
  push_matrix
  translate 360, 80
  fill redder
  rect 0, 0, 200, 200
  fill orangish
  rect 40, 60, 120, 120
  fill yellower
  rect 60, 90, 80, 80
  pop_matrix
end

