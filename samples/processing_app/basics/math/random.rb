# Random. 
# 
# Random numbers create the basis of this image. 
# Each time the program is loaded the result is different. 

class Random < Processing::App

  def setup
    
    size 200, 200
    
    smooth
    stroke_weight 10
    
    no_loop
    
  end
  
  def draw
  	
    background 0
    
    (0...width).each { |i|
    
    	r = random 255
    	x = random 0, width
    	stroke r, 100
    	line i, 0, x, height
    }
    
  end
  
end

Random.new :title => "Random"