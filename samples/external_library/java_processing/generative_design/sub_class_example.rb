load_libraries 'generativedesign'

java_import "generativedesign.Mesh"

attr_reader :my_mesh

def setup
	size(1000, 1000, P3D)    
	color_mode(HSB, 360, 100, 100, 100)
	noStroke
	@my_mesh = MyOwnMesh.new(self)
	my_mesh.setUCount(100) # don't try snake case here
	my_mesh.setVCount(100) # don't try snake case here
	my_mesh.setColorRange(193, 193, 30, 30, 85, 85, 100) # don't snake case here
	my_mesh.update
end

def draw
	background(255)    
	# setup lights
	color_mode(RGB, 255, 255, 255, 100)
	light_specular(255, 255, 255) 
	directional_light(255, 255, 255, 1, 1, -1) 
	shininess(5.0)
	# setup view    
	translate(width/2, height/2)
	scale(180)
	my_mesh.draw    
end

class MyOwnMesh < Mesh
	A = 2/3.0
	B = sqrt(2)
	def initialize(the_parent)
	  super        
	end    
	# just override this function and put your own formulas inside
	def calculatePoints(u,  v)	# NB: don't try snake case here
	  x = A *  (cos(u) * cos(2 * v) + B * sin(u) * cos(v)) * cos(u) / (B - sin(2 * u) * sin(3 * v))
	  y = A * (cos(u) * sin(2 * v) - B * sin(u) * sin(v)) * cos(u) / (B - sin(2 * u) * sin(3 * v))
	  z = B * cos(u) * cos(u) / (B - sin(2 * u) * sin(3 * v))
	  return PVector.new(x, y, z)
	end
end
