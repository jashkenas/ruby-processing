require 'ruby-processing'

# Subtractive Color Wheel 
# by Ira Greenberg. 
# 
# The primaries are red, yellow, and blue. The
# secondaries are green, purple, and orange. The 
# tertiaries are  yellow-orange, red-orange, red-purple, 
# blue-purple, blue-green, and yellow-green.
# 
# Create a shade or tint of the 
# subtractive color wheel using
# SHADE or TINT parameters.

class ColorWheel < Processing::App

  def setup
    background 127
    smooth
    ellipse_mode RADIUS
    no_stroke
    
    create_wheel width/2, height/2, :tint # use :shade or :tint
  end
  
  
  def create_wheel( x, y, value_shift )
  
  	segs = 12
  	steps = 6
  	rot_adjust = radians( 360.0 / segs / 2.0 )
  	radius = 95.0
  	seg_width = radius / steps
  	interval = TWO_PI / segs
  
  	case value_shift
  	when :shade
  		0.upto(steps-1) do |j|
  			cols = [
  				color(255-(255/steps)*j, 255-(255/steps)*j, 0), 
				color(255-(255/steps)*j, (255/1.5)-((255/1.5)/steps)*j, 0), 
				color(255-(255/steps)*j, (255/2)-((255/2)/steps)*j, 0), 
				color(255-(255/steps)*j, (255/2.5)-((255/2.5)/steps)*j, 0), 
				color(255-(255/steps)*j, 0, 0), 
				color(255-(255/steps)*j, 0, (255/2)-((255/2)/steps)*j), 
				color(255-(255/steps)*j, 0, 255-(255/steps)*j), 
				color((255/2)-((255/2)/steps)*j, 0, 255-(255/steps)*j), 
				color(0, 0, 255-(255/steps)*j),
				color(0, 255-(255/steps)*j, (255/2.5)-((255/2.5)/steps)*j), 
				color(0, 255-(255/steps)*j, 0), 
				color((255/2)-((255/2)/steps)*j, 255-(255/steps)*j, 0)
  			]
  			0.upto(segs-1) do |i|
  				fill cols[i]
  				arc x, y, radius, radius, interval*i+rot_adjust, interval*(i+1)+rot_adjust
  			end
  			radius -= seg_width
  		end
  	when :tint
  		0.upto(steps-1) do |j|
  			cols = [
  				color((255/steps)*j, (255/steps)*j, 0), 
				color((255/steps)*j, ((255/1.5)/steps)*j, 0), 
				color((255/steps)*j, ((255/2)/steps)*j, 0), 
				color((255/steps)*j, ((255/2.5)/steps)*j, 0), 
				color((255/steps)*j, 0, 0), 
				color((255/steps)*j, 0, ((255/2)/steps)*j), 
				color((255/steps)*j, 0, (255/steps)*j), 
				color(((255/2)/steps)*j, 0, (255/steps)*j), 
				color(0, 0, (255/steps)*j),
				color(0, (255/steps)*j, ((255/2.5)/steps)*j), 
				color(0, (255/steps)*j, 0), 
				color(((255/2)/steps)*j, (255/steps)*j, 0)
  			]
  			0.upto(segs-1) do |i|
  				fill cols[i]
  				arc x, y, radius, radius, interval*i+rot_adjust, interval*(i+1)+rot_adjust
  			end
  			radius -= seg_width
  		end
  	end
  end
  
end

ColorWheel.new :title => "Color Wheel", :width => 200, :height => 200