#
#  Raycast
#
#  by Ricard Marxer
#
#  This example shows how to use the raycasts.
#
load_library :fisica

module Fisica
  include_package 'fisica'
end


attr_reader :world, :obstacle

def setup
  size(400, 400)
  smooth
  
  Fisica::Fisica.init(self)
  
  @world = Fisica::FWorld.new
  
  @obstacle = Fisica::FBox.new(150, 150)
  obstacle.set_rotation(QUARTER_PI)
  obstacle.set_position(width/2, height/2)
  obstacle.set_static(true)
  obstacle.set_fill(0)
  obstacle.set_restitution(0)
  world.add(obstacle)
end

def draw
  background(255)  
  world.draw
  world.step  
  cast_ray
end

def cast_ray
  result = Fisica::FRaycastResult.new
  b = world.raycast_one(width/2, height, mouse_x, mouse_y, result, true)  
  stroke(0)
  line(width/2, height, mouse_x, mouse_y)  
  if (b)
    b.set_fill(120, 90, 120)
    fill(180, 20, 60)
    no_stroke    
    x = result.get_x
    y = result.get_y
    ellipse(x, y, 10, 10)    
  else
    obstacle.set_fill(0)
  end
end

def key_pressed  
  save_frame("screenshot.png")  
end

