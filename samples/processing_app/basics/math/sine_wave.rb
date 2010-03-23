# Sine Wave
# by Daniel Shiffman.  
# 
# Render a simple sine wave. 

class SineWave < Processing::App

  def setup
    
    size 200, 200
    
    frame_rate 30
    color_mode RGB, 255, 255, 255, 100
    smooth
    
    @w = width + 16
    @period = 500.0
    @x_spacing = 8
    @dx = (TWO_PI / @period) * @x_spacing
    @y_values = []
    @theta = 0.0
    @amplitude = 75.0
    
  end
  
  def draw
  
  	background 0
  	calc_wave
  	draw_wave
  
  end
  
  def calc_wave
  
  	@theta += 0.02
  	
  	x = @theta
  	(0...(@w/@x_spacing)).each { |i|
  	
  		@y_values[i] = sin(x) * @amplitude
  		x += @dx
  	}
  
  end
  
  def draw_wave
  
	no_stroke
	fill 255, 50
	ellipse_mode CENTER
  		
  	@y_values.each_with_index { |v, x|
  	
  		ellipse x*@x_spacing, width/2+v, 16, 16
  	}
  	
  end
  
end

SineWave.new :title => "Sine Wave"