require 'ruby-processing'

# Bezier Ellipse  
# By Ira Greenberg 
# 
# Generates an ellipse using bezier and
# trig functions. Approximately every 1/2 
# second a new ellipse is plotted using 
# random values for control/anchor points.

class BezierEllipse < Processing::App

  # have Ruby add getter/setter functions for these,
	# so we don't have to write "@var" all the time
	attr_accessor :px, :py, :cx, :cy, :cx2, :cy2 

  def setup
  	@color_controls = 0xFF222222
  	@color_anchors  = 0xFFBBBBBB
  	
  	smooth
  	rect_mode CENTER
    set_ellipse 4, 65, 65
    frame_rate 1
  end
  
  def draw
  	background 145
  	draw_ellipse
  	set_ellipse random(3, 12).to_i, random(-100, 150), random(-100, 150)
  end
  
  def draw_ellipse
  
  	number_of_points = px.length # all our arrays have same length
  
  	# draw shape
  
  	stroke_weight 1.125
  	stroke 255
  	no_fill
  	
  	number_of_points.times do |i|
  		i2 = (i+1) % number_of_points  # wrap around to make a loop
		  bezier px[i], py[i], 
			       cx[i], cy[i], 
			       cx2[i], cy2[i], 
			       px[i2], py[i2]
  	end
  	  	
  	# draw lines and handles
  	
  	stroke_weight 0.75
  	stroke 0
  	
  	number_of_points.times do |i|
  		i2 = (i+1) % number_of_points
  		line px[i], py[i], cx[i], cy[i]      # anchor to control 1
  		line cx2[i], cy2[i], px[i2], py[i2]  # control 2 to next anchor
  	end
  	
  	number_of_points.times do |i|
  		fill @color_controls
  		no_stroke
  		
  		ellipse cx[i], cy[i], 4, 4
  		ellipse cx2[i], cy2[i], 4, 4
  		
  		fill @color_anchors
  		stroke 0
  		
  		rect px[i], py[i], 5, 5
  	end
  end
  
  def set_ellipse( points, radius, control_radius )
  
	# first time we come here the instance variables are created
	# therefore we need to use "@" or "self.". the former will access the variable
	# directly the later will use the setter function created by "attr_accessor".
  	@px , self.py , @cx , @cy , @cx2 , @cy2 = [], [], [], [], [], [] 

  	angle = 360.0/points
  	control_angle_1 = angle/3.0
  	control_angle_2 = control_angle_1*2.0
  	points.times do |i|
  		px[i] = width/2+cos(angle.radians)*radius
  		
    	py[i] = height/2+sin(angle.radians)*radius
    	
    	cx[i] = width/2+cos((angle+control_angle_1).radians)* 
      			control_radius/cos((control_angle_1).radians)
      			
    	cy[i] = height/2+sin((angle+control_angle_1).radians)* 
      			control_radius/cos((control_angle_1).radians)
      			
    	cx2[i] = width/2+cos((angle+control_angle_2).radians)* 
      			control_radius/cos((control_angle_1).radians)
      			
    	cy2[i] = height/2+sin((angle+control_angle_2).radians)* 
      			control_radius/cos((control_angle_1).radians)

    	#increment angle so trig functions keep chugging along
    	angle += 360.0/points
  	end
  end
  
end

BezierEllipse.new :title => "Bezier Ellipse", :width => 200, :height => 200