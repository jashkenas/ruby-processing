#
#  Polygons
#
#  by Ricard Marxer
#
#  This example shows how to create polygon bodies.
#

load_library :fisica
include_package 'fisica'

attr_reader :world, :poly

def setup
  size(400, 400)
  smooth  
  Fisica.init(self)  
  @world = FWorld.new
  world.set_gravity(0, 800)
  world.set_edges
  world.remove(world.left)
  world.remove(world.right)
  world.remove(world.top)  
  world.set_edges_restitution(0.5)
end

def draw
  background(255)  
  world.step
  world.draw(self)   
  # Draw the polygon while
  # while it is being created
  # and hasn't been added to the
  # world yet  
  poly.draw(self) if (poly)  
end

def mouse_pressed
  unless (world.get_body(mouse_x, mouse_y))    
    @poly = FPoly.new
    poly.set_stroke_weight(3)
    poly.set_fill(120, 30, 90)
    poly.set_density(10)
    poly.set_restitution(0.5)
    poly.vertex(mouse_x, mouse_y)
  end
end

def mouse_dragged  
  poly.vertex(mouse_x, mouse_y) if (poly)
end

def mouse_released
  if (poly)
    world.add(poly)
    @poly = nil
  end
end

#
# Remove object under mouse using backspace 'key'
# any other key should save
#

def key_pressed
  if key_code == BACKSPACE
    hovered = world.get_body(mouse_x, mouse_y)
    if (hovered && hovered.is_static == false)
      world.remove(hovered)
    end    
  else    
    save_frame("screenshot.png")    
  end
end





