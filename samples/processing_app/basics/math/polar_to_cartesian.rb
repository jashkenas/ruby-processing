# PolarToCartesian
# by Daniel Shiffman.  
# 
# Convert a polar coordinate (r,theta) to cartesian (x,y):  
# x = r * cos(theta)
# y = r * sin(theta)
 
class PolarToCartesian < Processing::App

  def setup
    
    size 200, 200
    
    frame_rate 30
    smooth
    
    @r = 50.0
    @theta = 0.0
    @theta_vel = 0.0
    @theta_acc = 0.1e-3
  end
  
  def draw
  
  	background 0
  	
  	translate width/2, height/2
  	
  	x = @r * cos( @theta )
  	y = @r * sin( @theta )
  	
  	ellipse_mode CENTER
  	no_stroke
  	fill 200
  	ellipse x, y, 16, 16
  	
  	@theta_vel += @theta_acc
  	@theta += @theta_vel
  
  end
  
end

PolarToCartesian.new :title => "Polar To Cartesian"