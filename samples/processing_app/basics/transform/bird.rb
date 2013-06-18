# Simple 3D Bird 
# by Ira Greenberg.  
# 
# Using a box and 2 rects to simulate a flying bird. 
# Trig functions handle the flapping and sinuous movement.
attr_reader :ang, :ang2, :ang3, :ang4, :flap_speed

def setup
  
  size 640, 360, P3D
  
  no_stroke
  
  @ang, @ang2, @ang3, @ang4 = 0.0, 0.0, 0.0, 0.0
  @flap_speed = 0.2
  
end

def draw
  
  background 0
  lights
  
  px = sin( ang3.radians ) * 170
  py = cos( ang3.radians ) * 300
  pz = sin( ang4.radians ) * 500
  
  translate width/2 + px, height/2 + py, -700 + pz
  
  rotate_x sin( ang2.radians ) * 120
  rotate_y sin( ang2.radians ) * 50
  rotate_z sin( ang2.radians ) * 65
  
  fill 153
  box 20, 100, 20
  
  fill 204
  push_matrix
  rotate_y sin( ang.radians ) * -20
  rect -75, -50, 75, 100
  pop_matrix
  
  push_matrix
  rotate_y sin( ang.radians ) * 20
  rect 0, -50, 75, 100
  pop_matrix
  
  @ang += flap_speed
  
  @flap_speed *= -1 if abs(ang) > PI
  
  @ang2 += 0.01
  @ang3 += 2.0
  @ang4 += 0.75
  
end

