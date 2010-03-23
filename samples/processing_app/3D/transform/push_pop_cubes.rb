# PushPop Cubes  
# by Ira Greenberg.  
# 
# Array of rotating cubes creates
# dynamic field patterns. Color
# controlled by light sources. Example 
# of pushMatrix() and popMatrix().

class PushPopCubes < Processing::App

  def setup
    
    size 640, 360, P3D
    
    @cols = 21
    @rows = 21
    @cube_count = @cols * @rows
    @cubes = []
    @rot_vals = []
    @angls = []
    @rotspd = 2.0
    
    @col_span = width / (@cols-1)
    @row_span = height/ (@rows-1)
    
    no_stroke
    
    (0...@cube_count).each { |i|
    
    	@cubes.push Cube.new( 12, 12, 6, 0, 0, 0 )
    	
    	#3 different rotation options
       	#	- 1st option: cubes each rotate uniformly
       	#	- 2nd option: cubes each rotate randomly
       	#	- 3rd option: cube columns rotate as waves
       	#To try the different rotations, leave one 
       	#of the "@rotVals.push ..." lines uncommented below
       	#and the other 2 commented out.
       	
       	#@rot_vals.push @rotspd
       	#@rot_vals.push random( -@rotspd * 2, @rotspd * 2 )
       	@rot_vals.push @rotspd += 0.01
       	
       	@angls.push 0.0
    }
    
  end
  
  def draw
  
  	background 0
  	fill 200
  	
  	point_light  51, 102, 255, width/3,   height/2,  100
  	point_light 200,  40,  60, width/1.5, height/2, -150
  	
  	ambient_light 170, 170, 100
  	
  	cube_counter = 0
  	
  	(0...@cols).each { |i|
  		(0...@rows).each { |j|
  		
  			push_matrix
  			
  			translate i * @col_span, j * @row_span, -20
  			
  			rotate_y radians( @angls[cube_counter] )
  			rotate_x radians( @angls[cube_counter] )
  			
  			@cubes[cube_counter].draw_cube
  			
  			pop_matrix
  			
  			cube_counter += 1
  		
  		}
  	}
  	
  	(0...@cube_count).each { |i| @angls[i] += @rot_vals[i] }
  
  end
  
  # Simple Cube class, based on Quads
  class Cube

	  # Properties
	  attr_accessor :w, :h, :d
	  attr_accessor :shiftX, :shiftY, :shiftZ

	  # Constructor
	  def initialize ( w, h, d, shiftX, shiftY, shiftZ )
	  @w = w;
	  @h = h;
	  @d = d;
	  @shiftX = shiftX;
	  @shiftY = shiftY;
	  @shiftZ = shiftZ;
	  end

	  #Main cube drawing method, which looks 
          #more confusing than it really is. It's 
          #just a bunch of rectangles drawn for 
          #each cube face
	  def draw_cube

		  # Front face
		  beginShape QUADS
		  
		  vertex -@w/2 + @shiftX, -@h/2 + @shiftY, -@d/2 + @shiftZ 
		  vertex  @w   + @shiftX, -@h/2 + @shiftY, -@d/2 + @shiftZ 
		  vertex  @w   + @shiftX,  @h   + @shiftY, -@d/2 + @shiftZ 
		  vertex -@w/2 + @shiftX,  @h   + @shiftY, -@d/2 + @shiftZ 
		  
		  # Back face
		  vertex -@w/2 + @shiftX, -@h/2 + @shiftY, @d + @shiftZ 
		  vertex  @w   + @shiftX, -@h/2 + @shiftY, @d + @shiftZ 
		  vertex  @w   + @shiftX,  @h   + @shiftY, @d + @shiftZ 
		  vertex -@w/2 + @shiftX,  @h   + @shiftY, @d + @shiftZ
		  
		  # Left face
		  vertex -@w/2 + @shiftX, -@h/2 + @shiftY, -@d/2 + @shiftZ 
		  vertex -@w/2 + @shiftX, -@h/2 + @shiftY,  @d   + @shiftZ 
		  vertex -@w/2 + @shiftX,  @h   + @shiftY,  @d   + @shiftZ 
		  vertex -@w/2 + @shiftX,  @h   + @shiftY, -@d/2 + @shiftZ 
		  
		  # Right face
		  vertex @w + @shiftX, -@h/2 + @shiftY, -@d/2 + @shiftZ 
		  vertex @w + @shiftX, -@h/2 + @shiftY,  @d   + @shiftZ 
		  vertex @w + @shiftX,  @h   + @shiftY,  @d   + @shiftZ 
		  vertex @w + @shiftX,  @h   + @shiftY, -@d/2 + @shiftZ 
		  
		  # Top face
		  vertex -@w/2 + @shiftX, -@h/2 + @shiftY, -@d/2 + @shiftZ 
		  vertex  @w   + @shiftX, -@h/2 + @shiftY, -@d/2 + @shiftZ 
		  vertex  @w   + @shiftX, -@h/2 + @shiftY,  @d   + @shiftZ 
		  vertex -@w/2 + @shiftX, -@h/2 + @shiftY,  @d   + @shiftZ 
		  
		  # Bottom face
		  vertex -@w/2 + @shiftX, @h + @shiftY, -@d/2 + @shiftZ 
		  vertex  @w   + @shiftX, @h + @shiftY, -@d/2 + @shiftZ 
		  vertex  @w   + @shiftX, @h + @shiftY,  @d   + @shiftZ 
		  vertex -@w/2 + @shiftX, @h + @shiftY,  @d   + @shiftZ
		  
	  end_shape
	  end
  
  end #class Cube
  
end

PushPopCubes.new :title => "Push Pop Cubes"