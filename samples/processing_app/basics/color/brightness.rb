require 'ruby-processing'

# Brightness 
# by Rusty Robison. 
# 
# Brightness is the relative lightness or darkness of a color.
# Move the cursor vertically over each bar to alter its brightness. 

class Brightness < Processing::App

  def setup
    color_mode HSB, 360, height, height
    @bar_width = 5
    @brightness = Array.new width/@bar_width, 0
  end
  
  def draw
  	no_stroke
  	i = 0; j = 0; while i <= (width - @bar_width)
  	
  		@brightness[j] = mouse_y if (mouse_x > i) and mouse_x < (i + @bar_width)
  		fill i, height, @brightness[j]
  		rect i, 0, @bar_width, height
  		
  	j += 1; i += @bar_width; end
  end
  
end

Brightness.new :title => "Brightness", :width => 200, :height => 200