# Distance 1D. 
# 
# Move the mouse left and right to control the 
# speed and direction of the moving shapes. 

class Distance1 < Processing::App

  def setup
    
    size 200, 200
    no_stroke
    frame_rate 60
    
    @thin = 8
    @thick = 36
    @xpos1 = 134
    @xpos2 = 44
    @xpos3 = 58
    @xpos4 = 120
    
  end
  
  def draw
  
  	background 0
  	
  	mx = mouse_x * 0.4 - width / 5.0
  	
  	fill 102
  	rect @xpos2, 0, @thick, height/2
  	
  	fill 204
  	rect @xpos1, 0, @thin, height/2
  	
  	fill 102
  	rect @xpos4, height/2, @thick, height/2
  	
  	fill 204
  	rect @xpos3, height/2, @thin, height/2
  	
  	@xpos1 += mx/16
  	@xpos2 += mx/64
  	@xpos3 -= mx/16
  	@xpos4 -= mx/64
  	
  	@xpos1 = width if @xpos1 < -@thin
  	@xpos1 = -@thin if @xpos1 > width
  	@xpos2 = width if @xpos2 < -@thick
  	@xpos2 = -@thick if @xpos2 > width
  	@xpos3 = width if @xpos3 < -@thin
  	@xpos3 = -@thin if @xpos3 > width
  	@xpos4 = width if @xpos4 < -@thick
  	@xpos4 = -@thick if @xpos4 > width
  
  end
  
end

Distance1.new :title => "Distance1"