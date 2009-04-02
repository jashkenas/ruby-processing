# Move the mouse left and right to change the field of view (fov).
# Click to modify the aspect ratio. The perspective method
# sets a perspective projection applying foreshortening, making 
# distant objects appear smaller than closer ones. The parameters 
# define a viewing volume with the shape of truncated pyramid. 
# Objects near to the front of the volume appear their actual size, 
# while farther objects appear smaller. This projection simulates 
# the perspective of the world more accurately than orthographic projection. 
# The version of perspective without parameters sets the default 
# perspective and the version with four parameters allows the programmer 
# to set the area precisely.

def setup
  size 640, 360, P3D
  no_stroke
end

def draw
  lights
  background 204
  camera_y = height/2.0
  fov = mouse_x/width.to_f * PI/2.0
  camera_z = camera_y / tan(fov / 2.0)
  aspect = width.to_f / height.to_f
  
  aspect /= 2.0 if mouse_pressed?
  
  perspective(fov, aspect, camera_z/10.0, camera_z*10.0)
  
  translate width/2.0+30, height/2.0, 0
  rotate_x -PI/6
  rotate_y PI/3 + mouse_y/height.to_f * PI
  box 45
  translate 0, 0, -50
  box 30
end