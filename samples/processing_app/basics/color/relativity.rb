require 'ruby-processing'

# Each color is perceived in relation to other colors. 
# The top and bottom bars each contain the same component colors,
# but a different display order causes individual colors to appear differently. 

class Relativity < Processing::App

  def setup
    
    a = color 165, 167, 20
  	b = color 77,  86,  59
  	c = color 42,  106, 105
  	d = color 165, 89,  20
  	e = color 146, 150, 127
  	
  	no_stroke
  	
  	draw_band [a, b, c, d, e], 0, 4
  	draw_band [c, a, d, b, e], height/2, 4
  end
  
  def draw_band( color_order, ypos, bar_width )
  	
  	num = color_order.length
  	
  	(0...width).step(bar_width * num) do |i|
  		num.times do |j|
  			fill color_order[j]
  			rect i + j*bar_width, ypos, bar_width, height/2
  		end
  	end
  	
  end
  
end

Relativity.new :title => "Relativity", :width => 200, :height => 200