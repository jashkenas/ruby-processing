# The Nature of Code
# <http://www.shiffman.net/teaching/nature>
# Spring 2011
# PBox2D example

# Basic example of falling rectangles
load_library :pbox2d
load_library :custom_shape

# module B2D is a wrapper for java imports, and Boundary and CustomShape classes
include B2D     

attr_reader :box2d, :boundaries, :polygons

def setup
  size(640,360)
  smooth  
  # Initialize box2d physics and create the world
  @box2d = PBox2D.new(self)
  box2d.create_world
  # We are setting a custom gravity
  box2d.set_gravity(0, -20)  
  # Create Arrays	
  @polygons = []
  @boundaries = []  
  # Add a bunch of fixed boundaries
  boundaries << Boundary.new(box2d, width / 4, height - 5, width/2 - 50, 10, 0)
  boundaries << Boundary.new(box2d, 3*width / 4, height - 50, width/2 - 50, 10, 0)
  boundaries << Boundary.new(box2d, width - 5,height / 2, 10, height, 0)
  boundaries << Boundary.new(box2d, 5, height / 2, 10, height, 0)
end

def draw
  background(255)  
  # We must always step through time!
  box2d.step  
  # Display all the boundaries
  boundaries.each do |wall|
    wall.display
  end
  
  # Display all the polygons
  polygons.each do |cs|
    cs.display
  end
  
  # polygons that leave the screen, we delete them
  # (note they have to be deleted from both the box2d world and our list
  polygons.each_with_index do |polygon, i|   
    if polygon.done
      polygons.delete_at(i)
    end
  end
end

def mouse_pressed  
  polygons << CustomShape.new(box2d, mouse_x, mouse_y)
end
