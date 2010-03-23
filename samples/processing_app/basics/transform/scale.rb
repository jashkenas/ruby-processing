# Scale 
# by Denis Grutze. 
# 
# Paramenters for the scale() function are values specified 
# as decimal percentages. For example, the method call scale(2.0) 
# will increase the dimension of the shape by 200 percent. 
# Objects always scale from the origin. 

class Scale < Processing::App

  def setup
    
    size 200, 200
    
    no_stroke
    rect_mode CENTER
    
    frame_rate 30
    
    @a, @s = 0.0, 0.0
  end
  
  def draw
  
  	background 102
  	
  	@a += 0.04
  	@s = cos( @a ) * 2
  	
  	translate width/2, height/2
  	scale @s
  	
  	fill 51
  	rect 0, 0, 50, 50
  	
  	translate 75, 0
  	
  	fill 255
  	scale @s
  	rect 0, 0, 50, 50
  end
  
end

Scale.new :title => "Scale"