# Move Eye. 
# by Simon Greenwold.
# 
# The camera lifts up (controlled by mouseY) while looking at the same point.

class MoveEye < Processing::App

  def setup
    size 640, 360, P3D
    fill 204
  end
  
  def draw
  	lights
  	background 0
  	
  	camera 30, mouseY, 220, 0, 0, 0, 0, 1, 0
  	
  	noStroke
  	box 90
  	stroke 255
  	line( -100, 0, 0, 100, 0, 0)
  	line( 0, -100, 0, 0, 100, 0)
  	line( 0, 0, -100, 0, 0, 100)
  end
  
end

MoveEye.new :title => "Move Eye"