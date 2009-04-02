# Click to see the difference between orthographic projection
# and perspective projection as applied to a simple box.
# The ortho function sets an orthographic projection and 
# defines a parallel clipping volume. All objects with the 
# same dimension appear the same size, regardless of whether 
# they are near or far from the camera. The parameters to this 
# function specify the clipping volume where left and right 
# are the minimum and maximum x values, top and bottom are the 
# minimum and maximum y values, and near and far are the minimum 
# and maximum z values.

def setup
  size 640, 360, P3D
  no_stroke
  fill 204
end

def draw
  background 0
  lights
  
  mouse_pressed? ? show_perspective : show_orthographic
  
  translate width/2, height/2, 0
  rotate_x -PI/6
  rotate_y PI/3
  box 160
end

def show_perspective
  fov = PI/3.0
  camera_z = (height/2.0) / tan(PI * fov / 360.0)
  perspective fov, width.to_f/height.to_f, camera_z/2.0, camera_z*2.0
end

def show_orthographic
  ortho -width/2, width/2, -height/2, height/2, -10, 10
end