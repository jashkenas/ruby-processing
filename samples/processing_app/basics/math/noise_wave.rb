# Noise Wave

class NoiseWave < Processing::App

  def setup
    
    size 200, 200
    frame_rate 30
    
    color_mode RGB, 255, 255, 255, 100
    smooth
    @w = width + 16
    @y_values = []
    @x_spacing = 8
    @yoff = 0.0
    
  end
  
  def draw
  
  	background 0
  	
  	calc_wave
  	draw_wave
  
  end
  
  def calc_wave
  	
  	dx = 0.05
  	dy = 0.01
  	amplitude = 100.0
  	
  	@yoff += dy
  	
  	xoff = @yoff
  	
  	(0...(@w/@x_spacing)).each { |i|
  	
  		@y_values[i] = (2 * noise(xoff) - 1) * amplitude
  		xoff += dx
  	}
  	
  end
  
  def draw_wave
  	
	no_stroke
	fill 255, 50
	ellipse_mode CENTER
  
  	@y_values.each_with_index { |v, x|
  		
  		ellipse x * @x_spacing, width/2 + v, 16, 16
  	}
  
  end
  
end

NoiseWave.new :title => "Noise Wave"