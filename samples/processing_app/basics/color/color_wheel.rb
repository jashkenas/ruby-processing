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
    
    @style = :tint # use :shade or :tint
    create_wheel width/2, height/2, @style
  end
  
  
  def create_wheel( x, y, value_shift )
  
  	segs        = 12
  	steps       = 6
  	rot_adjust  = (360.0 / segs / 2.0) * PI / 180
  	radius      = 95.0
  	seg_width   = radius / steps
  	interval    = TWO_PI / segs
  
  	case value_shift
  	when :shade
  		steps.times do |j|
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
  			segs.times do |i|
  				fill cols[i]
  				arc x, y, radius, radius, interval*i+rot_adjust, interval*(i+1)+rot_adjust
  			end
  			radius -= seg_width
  		end
  		
  	when :tint
  		steps.times do |j|
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
  			segs.times do |i|
  				fill cols[i]
  				arc x, y, radius, radius, interval*i+rot_adjust, interval*(i+1)+rot_adjust
  			end
  			radius -= seg_width
  		end
  	end
  end
  
  def draw
    # Empty draw method. Things only change when you click.
  end
  
  def mouse_pressed
    @style = @style == :tint ? :shade : :tint
    create_wheel width/2, height/2, @style
  end
  
end

ColorWheel.new :title => "Color Wheel", :width => 200, :height => 200