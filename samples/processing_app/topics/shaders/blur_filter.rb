#
# Blur Filter
# 
# Change the default shader to apply a simple, custom blur filter.
# 
# Press the mouse to switch between the custom and default shader.
#

attr_reader :blur

def setup
  size(640, 360, P2D)
  @blur = load_shader("blur.glsl"); 
  stroke(255, 0, 0)
  rectMode(CENTER)
end

def draw
  filter(blur);  
  rect(mouse_x, mouse_y, 150, 150); 
  ellipse(mouse_x, mouse_y, 100, 100)
end



