require 'ruby-processing'

# Pointillism
# by Daniel Shiffman. 
# 
# Mouse horizontal location controls size of dots. 
# Creates a simple pointillist effect using ellipses colored
# according to pixels in an image. 

class Pointillism < Processing::App

  def setup
    @a = load_image "eames.jpg"
    
    no_stroke
    background 255
    smooth
  end
  
  def draw
  	pointillize = map mouse_x, 0, width, 2, 18
  	x = random(@a.width).to_i
  	y = random(@a.height).to_i
  	pixel = @a.get x, y
  	fill pixel
  	ellipse x, y, pointillize, pointillize
  end
  
end

Pointillism.new :title => "Pointillism", :width => 200, :height => 200