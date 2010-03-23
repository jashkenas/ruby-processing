# Double Random 
# by Ira Greenberg.  
# 
# Using two random() calls and the point() function 
# to create an irregular sawtooth line.

class DoubleRandom < Processing::App

  def setup
    
    size 200, 200
    
    background 0
    
    total_pts = 300
    
    steps = total_pts + 1.0
    
    stroke 255
    
    rand = 0
    
    (1...steps).each { |i|
    
    	point( (width/steps) * i, height/2 + random( -rand, rand ) )
    	rand += random( -5, 5 )
    
    }
    
  end
  
  def draw
  
  end
  
end

DoubleRandom.new :title => "Double Random"