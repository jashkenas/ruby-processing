attr_reader :cube

def setup
  size(400, 400, P3D)
  smooth
  @cube = create_shape(BOX, 100)
end

def draw
  background(120)    
  lights    
  translate(mouse_x, mouse_y)
  rotate_x(frame_count * 0.01)
  rotate_y(frame_count * 0.01)    
  shape(cube)    
end

def key_pressed
  # Changing the smooth configuration restarts the OpenGL surface. 
  # Automatically recreates all the current GL resources.
  no_smooth
end
