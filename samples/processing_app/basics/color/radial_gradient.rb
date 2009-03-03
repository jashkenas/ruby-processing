require 'ruby-processing'

# Simple Radial Gradient 
# by Ira Greenberg. 
# 
# Using the convenient red(), green() 
# and blue() component functions,
# generate an array of radial gradients.

class RadialGradient < Processing::App

  def setup
    
    background 0
    smooth
    
    columns = 4
    radius = (width / columns) / 2
    diameter = radius * 2
    
    (width / diameter).times do |left|
    	(height / diameter).times do |top|
    		create_gradient( radius + left*diameter, 
    						 radius + top*diameter, 
    						 radius,
    						 color( random(255).to_int, random(255).to_int, random(255).to_int ),
    						 color( random(255).to_int, random(255).to_int, random(255).to_int ) )
    	end
    end
    
  end
  
  def create_gradient( x, y, radius, c1, c2 )
  	
  	px = 0.0
  	py = 0.0
  	
  	deltaR = red( c2 )   - red( c1 )
  	deltaG = green( c2 ) - green( c1 )
  	deltaB = blue( c2 )  - blue( c1 )
  	
  	gap_filler = 8.0
  	
  	radius.times do |r|
  	
  		angle = 0.0
  		while angle < 360
  		
  			px = x + cos(radians( angle )) * r
  			py = y + sin(radians( angle )) * r
  			
  			c = color( red( c1 )   + r * (deltaR / radius),
      				   green( c1 ) + r * (deltaG / radius),
      				   blue( c1 )  + r * (deltaB / radius) )
      				   
  			set px.to_i, py.to_i, c
  			
  			angle += 1 / gap_filler
  		end
  	end
  
  	no_fill
  	stroke_weight 3
  	ellipse x, y, radius*2, radius*2
  end
  
end

RadialGradient.new :title => "Radial Gradient", :width => 200, :height => 200