# Cubes Contained Within a Cube 
# by Ira Greenberg.  
# 
# Collision detection against all outer cube's surfaces. 
# Uses the PVector and Cube classes.

# fjenett, 2010-03-12: did some cleanups and rubyfication here

require 'cube'

class CubesInCube < Processing::App

  def setup
    
    size 640, 360, P3D
    
    lights
    
    @cube_count = 20
    @cubes = []
    
    0.upto( @cube_count ) { |i|
    
    	cube_size = random( 5, 15 )
    	
    	c = Cube.new cube_size, cube_size, cube_size
    	
    	c.position = PVector.new 0.0, 0.0, 0.0
    	c.speed    = PVector.new random(-1,1), random(-1,1), random(-1,1)
    	c.rotation = PVector.new random(40,100), random(40,100), random(40,100)
    	
    	@cubes.push c
    }
    
    @cube_colors = [
    	color( 0 ), color( 51 ), color( 102 ), color( 153 ), color( 204 ), color( 255 )
    ]
    @cube_colors.reverse
    
    @stage_size = 300
    @stage = Cube.new @stage_size, @stage_size, @stage_size
    
  end
  
  def draw
  
  	background 50
  
  	translate width/2, height/2, -130
  	
  	rotate_x frame_count * 0.001
  	rotate_y frame_count * 0.002
  	rotate_z frame_count * 0.001
  
  	no_fill
  	stroke 255
  	
  	@stage.draw
  	
  	@cubes.each_with_index { |c, i|
  	
  		# draw cube
  		push_matrix
  		
  			translate c.position.x, c.position.y, c.position.z
  			
  			fcpi = frame_count * PI
  			rotate_x fcpi / c.rotation.x
  			rotate_y fcpi / c.rotation.y
  			rotate_x fcpi / c.rotation.z
  			
  			no_stroke
  			
  			c.draw @cube_colors
  		
  		pop_matrix
  		
  		# move it
		c.position.add c.speed
		
		# draw lines
		if i > 0
		
			stroke 0
			c2 = @cubes[i-1]
			line c.position.x,  c.position.y,  c.position.z,
			     c2.position.x, c2.position.y, c2.position.z
		
		end
		
		# collision
		s2 = @stage_size / 2
		c.speed.x *= -1 if ( c.position.x / s2 ).abs > 1  # note that in Ruby abs(-12) is -12.abs
		c.speed.y *= -1 if ( c.position.y / s2 ).abs > 1
		c.speed.z *= -1 if ( c.position.z / s2 ).abs > 1
  	}
  	
  end
  
end

CubesInCube.new :title => "Cubes In Cube"
