require 'ruby-processing'

# Brightness 
# by Rusty Robison. 
# 
# Brightness is the relative lightness or darkness of a color.
# Move the cursor vertically over each bar to alter its brightness. 

class Brightness < Processing::App

  def setup
    no_stroke
    color_mode HSB, 360, height, height
    @bar_width = 5
    @brightness = Array.new(width/@bar_width, 0)
  end
  
  def draw
  	(width/@bar_width).times do |i|
  	  n = i * @bar_width
  	  range = (n..n+@bar_width)
  		@brightness[i] = mouse_y if range.include? mouse_x
  		fill n, height, @brightness[i]
  		rect n, 0, @bar_width, height
		end
  end
  
end

Brightness.new :title => "Brightness", :width => 200, :height => 200