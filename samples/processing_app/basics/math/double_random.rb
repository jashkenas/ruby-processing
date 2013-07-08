# Double Random 
# by Ira Greenberg.  
# 
# Using two rand(..) calls and the point() function to 
# create an irregular sawtooth line. The noise line guards 
# against an illegal input to rand range when min > max, 
# and to return min as vanilla processing does 
# (NB: the sawtooth relies on this)

attr_reader :steps

def setup  
  size 640, 360  
  frame_rate(1) 
  total_pts = 300  
  @steps = total_pts + 1.0
  stroke_weight 2
  stroke 255  
end

def draw
  background 0
  rand_y = 0.0  
  (1 ... steps).each do |i|
    noise_y = (rand_y > 0)? rand(-rand_y .. rand_y) : rand(rand_y .. -rand_y)    
    point( (width/steps) * i, (height/2) + noise_y )
    rand_y += rand(-5 .. 5)  
  end
end


