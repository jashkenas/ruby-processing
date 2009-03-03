require 'ruby-processing'

# Move the mouse across the screen to change the position
# of the circles. The positions of the mouse are recorded
# into an array and played back every frame. Between each
# frame, the newest value are added to the end of each array
# and the oldest value is deleted. 

class StoringInput < Processing::App

  def setup
    @num = 60
    @mx = Array.new @num, 0
    @my = Array.new @num, 0
    
    smooth
    no_stroke
    fill 255, 153
  end
  
  def draw
  	background 51
  	
  	(1...@num).each do |i|
  		@mx[i-1] = @mx[i]
  		@my[i-1] = @my[i]
  	end
  	
  	@mx[@num-1] = mouse_x
  	@my[@num-1] = mouse_y
  	
  	(0...@num).each do |i|
  		ellipse @mx[i], @my[i], i/2, i/2
  	end
  end
  
end

StoringInput.new :title => "Storing Input", :width => 200, :height => 200