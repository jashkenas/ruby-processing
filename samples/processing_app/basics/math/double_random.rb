# Double Random 
# by Ira Greenberg.  
# 
# Using two rand(..) calls and the point() function to 
# create an irregular sawtooth line. The noise line guards 
# against an illegal input to rand range when min > max, 
# and to return min as vanilla processing does 
# (NB: the sawtooth relies on this)



def setup
  
  size 200, 200
  
  background 0
  
  total_pts = 400
  
  steps = total_pts + 1.0

  stroke 255
  
  rand_y = 0

  (1 ... steps).each { |i|
    noise_y = (rand_y > 0)? rand(-rand_y .. rand_y): rand_y    
    point( (width/steps) * i, height/2 +  noise_y )
    rand_y += rand( -5.0 .. 5 )  # one as float get float range  
  }
  
end


