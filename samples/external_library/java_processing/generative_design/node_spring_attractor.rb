load_libraries 'generativedesign'

######################################
# node_spring_attractor.rb
# demonstrates use of a module to create
# a ruby namespace for a java package
######################################

module GD
  include_package "generativedesign"
end

attr_reader :nodeA, :nodeB, :attractor, :spring

def setup
  size(512, 512, P3D)
  lights
  smooth(8)
  fill(0)
  @nodeA = GD::Node.new(rand * width, rand * height, rand(-200 .. 200))
  @nodeB = GD::Node.new(rand * width, rand * height, rand(-200 .. 200))
  nodeA.setStrength(-2)
  nodeB.setStrength(-2)
  nodeA.setDamping(0.1)
  nodeB.setDamping(0.1)
  nodeA.setBoundary(0, 0, -300, width, height, 300)
  nodeB.setBoundary(0, 0, -300, width, height, 300)  
  @spring = GD::Spring.new(nodeA, nodeB)
  spring.setStiffness(0.7)
  spring.setDamping(0.9)
  spring.set_length(100)  
  @attractor = GD::Attractor.new(width/2, height/2, 0)
  attractor.setMode(GD::Attractor::SMOOTH)
  attractor.setRadius(200)
  attractor.setStrength(5)
end

def draw
  background(50, 50, 200)
  lights
  ambient_light(100, 100, 100)
  ambient(30)
  specular(30)
  # attraction between nodes
  nodeA.attract(nodeB)
  nodeB.attract(nodeA)
  # update spring
  spring.update
  # attract
  attractor.attract(nodeA)
  attractor.attract(nodeB)
  # update node positions
  nodeA.update
  nodeB.update
  # draw attractor
  stroke(0, 50)
  stroke_weight(5)
  no_fill
  line(attractor.x - 10, attractor.y, attractor.x + 10, attractor.y)
  line(attractor.x, attractor.y-10, attractor.x, attractor.y + 10)
  ellipse(attractor.x, attractor.y, attractor.radius * 2, attractor.radius * 2)
  # draw spring
  stroke(255, 0, 0, 255)
  stroke_weight(4)
  line(nodeA.x, nodeA.y, nodeA.z, nodeB.x, nodeB.y, nodeB.z)
  # draw nodes
  no_stroke
  fill(212)
  push_matrix
  translate(nodeA.x, nodeA.y, nodeA.z)
  sphere(20)
  pop_matrix
  push_matrix
  translate(nodeB.x, nodeB.y, nodeB.z)
  sphere(20)
  pop_matrix
end

def mouse_pressed
	nodeA.x = mouse_x
	nodeA.y = mouse_y
	nodeA.z = mouse_y - 256
end
