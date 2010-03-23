# Noise1D. 
# 
# Using 1D Perlin Noise to assign location. 

class Noise1D < Processing::App

  def setup
    
    size 200, 200
    
    @xoff = 0.0
    @x_increment = 0.01
    
    background 0
    frame_rate 30
    smooth
    no_stroke
    
  end
  
  def draw
  
  	fill 0, 10
  	rect 0, 0, width, height
  	
  	n = noise( @xoff ) * width
  	
  	@xoff += @x_increment
  	
  	fill 200
  	ellipse n, height/2, 16, 16
  
  end
  
end

Noise1D.new :title => "Noise 1 D"