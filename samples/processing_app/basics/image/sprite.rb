require 'ruby-processing'

# Sprite (Teddy)
# by James Patterson. 
# 
# Demonstrates loading and displaying a transparent GIF image. 

class Sprite < Processing::App

  def setup
    @teddy = load_image "teddy.gif"
    @xpos, @ypos = width/2, height/2
    @drag = 30.0
    
    frame_rate 60
  end
  
  def draw
  	background 102
  	
  	difx = mouse_x - @xpos - @teddy.width/2
  	if difx.abs > 1.0
  		@xpos += difx/@drag
  		@xpos = constrain( @xpos, 0, width-@teddy.width/2 )
  	end
  	
  	dify = mouse_y - @ypos - @teddy.height/2
  	if dify.abs > 1.0
  		@ypos += dify/@drag
  		@ypos = constrain( @ypos, 0, height-@teddy.height/2 )
  	end
  	
  	image @teddy, @xpos, @ypos
  end
  
end

Sprite.new :title => "Sprite", :width => 200, :height => 200