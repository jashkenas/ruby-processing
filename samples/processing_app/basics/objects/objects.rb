# Objects
# by hbarragan. 
# 
# Move the cursor across the image to change the speed and positions
# of the geometry. The class MRect defines a group of lines.
 
class Objects < Processing::App

  def setup
    
    size 200, 200
    
    fill 255, 204
    no_stroke
    
    @r1 = MRect.new 1, 134.0, 0.532, 0.083 * height, 10.0, 60.0
    @r2 = MRect.new 2, 44.0, 0.166, 0.332 * height, 5.0, 50.0
    @r3 = MRect.new 2, 58.0, 0.332, 0.4482 * height, 10.0, 35.0
    @r4 = MRect.new 1, 120.0, 0.0498, 0.913 * height, 15.0, 60.0
  end
  
  def draw
  
  	background 0
  
  	[@r1, @r2, @r3, @r4].each do |r| r.display end
  	
  	@r1.move   mouse_x - width / 2, 		mouse_y + height * 0.1, 	30.0
  	@r2.move( (mouse_x + width * 0.05) % width,	mouse_y + height * 0.025, 	20.0 )
  	@r3.move   mouse_x / 4,				mouse_y - height * 0.025, 	40.0
  	@r4.move   mouse_x - width / 2,			height - mouse_y,		50.0
  end
  
  # vvvv CLASS MRECT
  
  class MRect
  
  	attr_accessor :w, :xpos, :h, :ypos, :d, :t
  
  	def initialize ( iw, ixp, ih, iyp, id, it )
  	
  		@w, @h = iw, ih
  		@xpos, @ypos = ixp, iyp
  		@d, @t = id, it
  	end
  	
  	def move ( posx, posy, damping )
  		
  		dif = @ypos - posy
  		
  		@ypos -= dif / damping if dif.abs > 1
  		
  		dif = @xpos - posx
  		
  		@xpos -= dif / damping if dif.abs > 1
  	end
  	
  	def display
  	
  		0.upto(@t-1) { |i|
  		
  			rect @xpos + ( i * (@d + @w)), @ypos, @w, height * @h
  		}
  	end
  
  end
  
  # ^^^^ CLASS MRECT
  
end

Objects.new :title => "Objects"