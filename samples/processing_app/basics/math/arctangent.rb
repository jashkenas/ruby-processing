require 'ruby-processing'

 # Move the mouse to change the direction of the eyes. 
 # The atan2() function computes the angle from each eye 
 # to the cursor. 

class Arctangent < Processing::App

  def setup
    @eyes = [
	  Eye.new(  50,  16,  80),
	  Eye.new(  64,  85,  40),  
	  Eye.new(  90, 200, 120),
	  Eye.new( 150,  44,  40), 
	  Eye.new( 175, 120,  80)
    ]
    
    smooth
    no_stroke
  end
  
  def draw
  	background 102
  	
  	@eyes.each do |eye|
  		eye.update mouse_x, mouse_y
  		eye.display self
  	end
  end
  
  class Eye
  	def initialize( _x, _y, _s) # contructor, called by Eye.new
  		@x, @y, @size = _x, _y, _s
  	end
  	
  	def update( mx, my )
  		@angle = Arctangent::atan2( my-@y, mx-@x )
  	end
  	
  	def display( context )
  		context.push_matrix
  			context.translate @x, @y
  			context.fill 255
  			context.ellipse 0, 0, @size, @size
  			context.rotate @angle
  			context.fill 153
  			context.ellipse @size/4, 0, @size/2, @size/2
  		context.pop_matrix
  	end
  end
  
end

Arctangent.new :title => "Arctangent", :width => 200, :height => 200