# Rotate. 
# 
# Rotating a square around the Z axis. To get the results
# you expect, send the rotate function angle parameters that are
# values between 0 and PI*2 (TWO_PI which is roughly 6.28). If you prefer to 
# think about angles as degrees (0-360), you can use the radians() 
# method to convert your values. For example: scale(radians(90))
# is identical to the statement scale(PI/2). 

class Rotate < Processing::App

  def setup
    
    size 200, 200
    
    no_stroke
    fill 255
    frame_rate 30
    rect_mode CENTER
    
    @angle = 0.0
    @cosine = 0.0
    @jitter = 0.0
  end
  
  def draw
  
  	background 102
  	
  	@jitter = random -0.1, 0.1 if second % 2 == 0
  	
  	@angle += @jitter
  	@cosine = cos( @angle )
  	
  	translate width/2, height/2
  	rotate @cosine
  	
  	rect 0, 0, 115, 115
  end
  
end

Rotate.new :title => "Rotate"