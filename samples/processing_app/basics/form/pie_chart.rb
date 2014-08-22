

# Pie Chart  
# By Ira Greenberg 
# 
# Uses the arc() function to generate a pie chart from the data
# stored in an array.


def setup
  size 640, 360
  background 100
  smooth(4)
  no_stroke
  
  diameter = [width, height].min * 0.75
  angles = [30, 10, 45, 35 ,60, 38, 75, 67]
  last_angle = 0.0
  
  angles.each do |angle|
    fill angle * 3.0
    arc width/2, height/2, 	 						    # center x, y
    diameter, diameter,  						        # width, height
    last_angle, last_angle + angle.radians	# angles from, to
    last_angle += angle.radians
  end
end
