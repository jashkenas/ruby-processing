# Constructing a simple dimensional form with lines and rectangles.
# Changing the value of the variable 'd' scales the image.
# The four variables set the positions based on the value of 'd'. 


def setup
  size 640, 360  
	d = 70
	p1 = d
	p2 = p1 + d
	p3 = p2 + d
	p4 = p3 + d
	
	background 0
	translate(140, 0)
	
	# Draw gray box
	stroke 153 
	line p3, p3, p2, p3 
	line p2, p3, p2, p2 
	line p2, p2, p3, p2 
	line p3, p2, p3, p3 
	stroke_weight 2
	# Draw white points
	stroke 255 
	point p1, p1 
	point p1, p3  
	point p2, p4 
	point p3, p1  
	point p4, p2 
	point p4, p4
end
