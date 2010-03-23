# Sine. 
# 
# Smoothly scaling size with the sin() function.

class Sine < Processing::App

  def setup
    
    size 200, 200
    no_stroke
    smooth
    
    @diameter = 84.0
    @sin = 0.0
    @angle = 0.0
    @rad_points = 90
    
  end
  
  def draw
  
  	background 153
  	
  	translate 130, 65
  	
  	fill 255
  	ellipse 0, 0, 16, 16
  	
  	angle_rot = 0.0
  	fill 51
  	
  	(0...5).each { |i|
  	
  		push_matrix
  			rotate angle_rot - 45
  			ellipse -116, 0, @diameter, @diameter
  		pop_matrix
  		angle_rot += TWO_PI/5
  	}
  	
  	@diameter = 34 * sin( @angle ) + 168
  	@angle += 0.02
  	#@angle = 0.0 if @angle > TWO_PI
  
  end
  
end

Sine.new :title => "Sine"