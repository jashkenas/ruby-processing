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
  	i = 0; j = 0; while i <= (width - @bar_width)
  	
  		@hue[j] = mouseY if (mouseX > i) and (mouseX < (i + @bar_width))
  		fill @hue[j], height/1.2, height/1.2
  		rect i, 0, @bar_width, height
  	
  	j += 1; i += @bar_width; end
  end
  
end

Hue.new :title => "Hue", :width => 200, :height => 200