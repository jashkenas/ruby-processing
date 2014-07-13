# Crazy Flocking 3D Birds 
# by Ira Greenberg. 
# 
# Simulates a flock of birds using a Bird class and nested
# pushMatrix() / popMatrix() functions. 
# Trigonometry functions handle the flapping and sinuous movement.

load_library :bird 

BIRD_COUNT = 200

def setup  
  size 640, 360, P3D
  no_stroke
  lights
  @birds = (0 .. BIRD_COUNT).map {     
    Bird.new(rand(-300 .. 300), rand(-300 .. 300), rand(-2500 .. -500), rand(5 .. 30), rand(5 .. 30))   
    .set_flight(rand(20 .. 340), rand(30 .. 350), rand( 1000 .. 4800 ), rand(-160 .. 160), rand(-55 .. 55), rand(-20 .. 20))    
    .set_wing_speed(rand(0.1 .. 3.75))
    .set_rot_speed(rand(0.025 .. 0.15))    
  } 
end

def draw  
  background 0  
  translate width/2, height/2, -700  
  @birds.map {|b| b.fly} 
end

