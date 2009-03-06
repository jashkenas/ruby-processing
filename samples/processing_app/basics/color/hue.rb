require 'ruby-processing'

# Hue is the color reflected from or transmitted through an object 
# and is typically referred to as the name of the color (red, blue, yellow, etc.) 
# Move the cursor vertically over each bar to alter its hue. 

class Hue < Processing::App

  def setup
    @bar_width = 5
    @hue = Array.new( (width/@bar_width), 0 )
    
    color_mode HSB, 360, height, height
    no_stroke
  end
  
  def draw
  	(width/@bar_width).times do |i|
  	  n = i * @bar_width
  	  range = (n..n+@bar_width)
  	  @hue[i] = mouse_y if range.include?(mouse_x)
  		fill @hue[i], height/1.2, height/1.2
  		rect n, 0, @bar_width, height
		end
  end
  
end

Hue.new :title => "Hue", :width => 200, :height => 200