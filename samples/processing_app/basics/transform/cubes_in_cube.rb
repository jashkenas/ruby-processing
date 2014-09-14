# Cubes Contained Within a Cube 
# by Ira Greenberg.  
# 
# Collision detection against all outer cube's surfaces. 
# Uses the Vec3D and Cube classes.

# fjenett, 2010-03-12: did some cleanups and rubyfication here
# Martin Prout went a bit further on 2014-03-26

load_libraries :vecmath, :cube


def setup
  
  size 640, 360, P3D
  
  lights
  smooth 4
  @cube_count = 20
  @cubes = []
  
  0.upto( @cube_count ) do |i|    
    cube_size = rand(5..15)    
    c = Cube.new(cube_size)    
    c.position = Vec3D.new(0.0, 0.0, 0.0)
    c.speed    = Vec3D.new(rand(-1.0..1), rand(-1.0..1), rand(-1.0..1)) 
    c.rotation = Vec3D.new(rand(40..100), rand(40..100), rand(40..100))    
    @cubes << c
  end
  
  @cube_colors = [
  color(0), color(51), color(102), color(153), color(204), color(255)
  ]
  @cube_colors.reverse
  
  @stage_size = 300
  @stage = Cube.new @stage_size
  
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
  
  @cubes.each_with_index do |c, i|
  	
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
		c.position += c.speed
		
		# draw lines
		if i > 0
		  
			stroke 0
			c2 = @cubes[i - 1]
			line c.position.x,  c.position.y,  c.position.z,
			c2.position.x, c2.position.y, c2.position.z
			
		end
		
		# collision
		boundary = Boundary.new(-@stage_size / 2, @stage_size / 2)
		c.speed.x *= -1 unless boundary.include? c.position.x 
		c.speed.y *= -1 unless boundary.include? c.position.y
		c.speed.z *= -1 unless boundary.include? c.position.z
	end
	
end
  
Boundary = Struct.new(:lower, :upper) do
  def include? x
    (lower ... upper).cover? x
  end
end


