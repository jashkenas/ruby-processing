require 'ruby-processing'

# Wave Gradient 
# by Ira Greenberg.  
# 
# Generate a gradient along a sin() wave.

class WaveGradient < Processing::App

  def setup
  
  	background 200
  	
  	angle     = 0.0
  	px, py    = 0.0, 0.0
  	amplitude = 30.0
  	frequency = 0.0
  	fill_gap  = 2.5
  	
  	(height + 150).times do |i|
  	  i -= 75
  		angle = 0.0
  		frequency += 0.006
  		
  		(width + 75).times do |j|
  			py = i + sin( angle.radians ) * amplitude
  			angle += frequency
  			
  			c = color((py-i).abs * 255/amplitude,
  					      255 - (py-i).abs * 255/amplitude,
  					      j * (255.0/(width+50)))
  			
  			fill_gap.ceil.times do |filler|
  				set j-filler, py.to_i-filler, c
  				set j, py.to_i, c
  				set j+filler, py.to_i+filler, c
  			end
  		end
  	end
  	
  end
  
end

WaveGradient.new :title => "Wave Gradient", :width => 200, :height => 200