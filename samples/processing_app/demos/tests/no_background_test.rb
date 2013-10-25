def setup
  size(400, 400, P2D) 
  background(255, 0, 0)
  fill(255, 150)
end

def draw
  ellipse(mouse_x, mouse_y, 100, 100) 
end

