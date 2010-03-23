# Vertices 
# by Simon Greenwold.
# 
# Draw a cylinder centered on the y-axis, going down 
# from y=0 to y=height. The radius at the top can be 
# different from the radius at the bottom, and the 
# number of sides drawn is variable.
 
class Vertices < Processing::App

  def setup
    
    size 640, 360, P3D
    
  end
  
  def draw
  
  	background 0
  	lights
  	
  	translate width/2, height/2
  	
  	rotate_y map( mouse_x, 0, width, 0, PI )
  	rotate_z map( mouse_y, 0, height, 0, -PI )
  	
  	no_stroke
  	fill 255, 255, 255
  	
  	translate 0, -40
  	
  	draw_cylinder 10, 180, 200, 16 	# Draw a mix between a cylinder and a cone
  	#draw_cylinder 70,  70, 120, 64 	# Draw a cylinder
  	#draw_cylinder  0, 180, 200,  4 	# Draw a pyramid
  	 
  end
  
  def draw_cylinder ( top_radius, bottom_radius, tall, sides )
  
  	angle = 0
  	angle_inc = TWO_PI / sides
  	
  	begin_shape QUAD_STRIP  	
	0.upto(sides+1) { |i|
		vertex top_radius * cos(angle), 0, top_radius * sin(angle)
		vertex bottom_radius * cos(angle), tall, bottom_radius * sin(angle)
		angle += angle_inc
	}
  	end_shape
  
  	unless top_radius == 0
  		angle = 0
  		
  		begin_shape TRIANGLE_FAN
  		vertex 0, 0, 0
  		0.upto(sides+1){ |i|
			vertex top_radius * cos(angle), 0, top_radius * sin(angle)
			angle += angle_inc
  		}
  		end_shape
  		
  	end
  
  	unless bottom_radius == 0
  		angle = 0
  		
  		begin_shape TRIANGLE_FAN
  		vertex 0, 0, 0
  		0.upto(sides+1) { |i|
			vertex bottom_radius * cos(angle), tall, bottom_radius * sin(angle)
			angle += angle_inc
  		}
  		end_shape
  		
  	end
  
  end
  
end

Vertices.new :title => "Vertices"