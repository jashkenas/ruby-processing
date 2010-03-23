# Drawolver: draw 2D & revolve 3D

# Example to show how to extend Ruby classes in a usefull way and how to
# use PVector.

# 2010-03-22 - fjenett

class Drawvolver < Processing::App

	load_library :opengl

  def setup
    
    size 640, 360, (library_loaded?(:opengl) ? OPENGL : P3D)
    frame_rate 30
    
    reset_scene
  end
  
  def draw
  
  	background 255
  	
  	if ( !@drawing_mode )
	
		translate width/2, height/2
		rotate_x @rot_x
		rotate_y @rot_y
		@rot_x += 0.01
		@rot_y += 0.02
		translate( -width/2, -height/2 )
	end
  	
	no_fill
	stroke 0
	
	@points.each_pair { |ps, pe|
	
		line ps.x, ps.y, pe.x, pe.y
	}
	
	if ( !@drawing_mode )
		
		no_stroke
		fill 120
		lights
			
		@vertices.each_pair { |r1, r2|
		
			begin_shape TRIANGLE_STRIP
				
				[r1,r2].one_of_each { |v1, v2|
					
					vertex v1.x, v1.y, v1.z
					vertex v2.x, v2.y, v2.z
				}
			end_shape
		}
	end
	
  end
  
  def reset_scene
  
  	@drawing_mode = true
  	@points = []
    @rot_x = 0.0
    @rot_y = 0.0
  end
  
  def mouse_pressed
    reset_scene
    @points.push RPVector.new( mouse_x, mouse_y )
  end
  
  def mouse_dragged
  	@points.push RPVector.new( mouse_x, mouse_y )
  end
  
  def mouse_released
  	@points.push RPVector.new( mouse_x, mouse_y )
  	recalculate_shape
  end
  
  def recalculate_shape
  	
  	@vertices = []
  	@points.each_pair { |ps, pe|
		
		b = @points.last - @points.first
		len = b.mag
		b.normalize
		
		a = ps - @points.first
		
		dot = a.dot b
		
			b = b * dot
		
			normal = @points.first + b
			
			c = ps - normal
			nlen = c.mag
			
			@vertices.push []
			
			(0..360).step( 12 ) { |deg|
				
				ang = radians deg
				e = normal + c * cos( ang )
				e.z = c.mag * sin( ang )
				
				@vertices.last.push e
			}
	}
  	@drawing_mode = false
  end
  
end


# this is a custom extension of the default Array class allowing for
# more readable code above.
#
class Array

	# send pairs into a block:
	# array [1,2,3,4] sends
	# [1,2] , [2,3] , [3,4]
	def each_pair ( &block )
		i = 1
		while i < self.length do
			yield( self[i-1], self[i] );
			i = i + 1
		end
	end
	
	# send one item from each array, expects array to be 2D:
	# array [[1,2,3], [a,b,c]] sends
	# [1,a] , [2,b] , [3,c]
	def one_of_each ( &block )
		
		i = 0
		one = self[0]
		two = self[1]
		mi = one.length > two.length ? two.length : one.length
		while i < mi do
			yield( one[i], two[i] )
			i = i + 1
		end
	end

end


# a wrapper around PVector that implements operators methods for +, -, *, /
#
class RPVector < Java::ProcessingCore::PVector

	def + ( other )
		v = RPVector.add( self, other )
		RPVector.new v.x, v.y, v.z
	end
	
	def - ( other )
		v = RPVector.sub( self, other )
		RPVector.new v.x, v.y, v.z
	end
	
	def * ( other )
		v = RPVector.mult( self, other )
		RPVector.new v.x, v.y, v.z
	end
	
	def / ( other )
		v = RPVector.div( self, other )
		RPVector.new v.x, v.y, v.z
	end

end

Drawvolver.new :title => "Drawvolver - fjenett 2010-03"