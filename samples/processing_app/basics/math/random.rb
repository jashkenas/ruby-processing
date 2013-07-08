# Random. 
# 
# Random numbers create the basis of this image. 
# Each time the program is loaded the result is different. 


def setup    
  size 640, 360
  stroke_weight 10    
  no_loop    
end

def draw  	
  background 0    
  (0...width).each do |i|    
    r = rand(255)
    x = rand(0 .. width)
    stroke(r, 100)
    line(i, 0, x, height)
  end    
end
