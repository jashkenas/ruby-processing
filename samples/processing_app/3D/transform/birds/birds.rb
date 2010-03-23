# Crazy Flocking 3D Birds 
# by Ira Greenberg. 
# 
# Simulates a flock of birds using a Bird class and nested
# pushMatrix() / popMatrix() functions. 
# Trigonometry functions handle the flapping and sinuous movement.

require 'bird' # class Bird

class Birds < Processing::App

  def setup
    
    size 640, 360, P3D
    no_stroke
    lights
    
    @bird_count = 200
    @birds = []
    
    0.upto( @bird_count ) { |i|
    
    	bird = Bird.new random(-300,300), random(-300,300), random(-500,-2500), random(5,30), random(5,30)
    
  		bird.set_flight random( 20, 340 ), random( 30, 350 ), random( 1000, 4800 ),
    					random( -160, 160 ), random( -55, 55 ), random( -20, 20 )
  		
  		bird.set_wing_speed random( 0.1, 3.75 )
  		bird.set_rot_speed random( 0.025, 0.15 )
    	
    	@birds.push bird
    }
    
  end
  
  def draw
  
  	background 0
  	
  	translate width/2, height/2, -700
  	
  	@birds.each do |b| b.fly end
  
  end
  
end

Birds.new :title => "Birds"