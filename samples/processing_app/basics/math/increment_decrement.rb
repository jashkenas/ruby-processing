# Increment Decrement. 
# 
# In Java and C ...
# Writing "a++" is equivalent to "a = a + 1".  
# Writing "a--" is equivalent to "a = a - 1". 

# In Ruby there is += 1 and -= 1:
# a += 1 is equal to a = a + 1

class IncrementDecrement < Processing::App

  def setup
    
    size 200, 200
    
    color_mode RGB, width
    
    @a = 0
    @b = width
    @direction = false
    
    frame_rate 30
    
  end
  
  def draw
  
  	@a += 1
  	
  	if @a > width
  		@a = 0
  		@direction = !@direction
  	end
  	
  	if @direction
  		stroke @a
  	else
  		stroke width-@a
  	end
  	
  	line @a, 0, @a, height/2
  	
  	@b -= 1
  	
  	@b = width if @b < 0
  	
  	if @direction
  		stroke width-@b
  	else
  		stroke @b
  	end
  	
  	line @b, height/2+1, @b, height
  
  end
  
end

IncrementDecrement.new :title => "Increment Decrement"