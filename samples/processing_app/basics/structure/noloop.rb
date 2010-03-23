# No Loop. 
# 
# The noLoop() function causes draw() to only
# execute once. Without calling noLoop(), draw()
# executed continually. 

class Noloop < Processing::App

  def setup
    
    size 200, 200
    
    @y = 100
    
    stroke 255
    frame_rate 30
    
    no_loop
  end
  
  def draw
  
  	background 0
  	
  	@y = @y - 1
  	@y = height if @y < 0
  	
  	line 0, @y, width, @y
  end
  
end

Noloop.new :title => "Noloop"