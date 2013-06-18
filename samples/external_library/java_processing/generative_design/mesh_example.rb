load_libraries 'generativedesign'

java_import "generativedesign.Mesh"

def setup
	size(1000,1000,P3D)	
	# setup drawing style 
	background(255)
	no_stroke
	fill(0)	
	# setup lights
	light_specular(230, 230, 230) 
	directional_light(200, 200, 200, 0.5, 0.5, -1) 
	specular(color(220)) 
	shininess(5.0) 
	# setup view
	translate(width * 0.5, height * 0.5)
	rotate_x(-0.2) 
	rotate_y(-0.5) 
	scale(100)	
	# setup Mesh, set colors and draw  
	myMesh = Mesh.new(self, Mesh::STEINBACHSCREW, 200, 200, -3.0, 3.0, -PI, PI)
	myMesh.setColorRange(200, 200, 50, 50, 40, 40, 100)
	myMesh.draw
end
