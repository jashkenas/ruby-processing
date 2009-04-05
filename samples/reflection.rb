# Taken from the Processing Examples.
  
def setup
  size 200, 200, P3D
  no_stroke
  color_mode RGB, 1
  fill 0.4
end

def draw
  background          0
  translate           width/2, height/2 
  light_specular      1, 1, 1
  directional_light   0.8, 0.8, 0.8, 0, 0, -1
  specular            mouse_x.to_f / width.to_f
  sphere              50
end