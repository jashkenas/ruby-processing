def setup
  size(400, 400, P3D)
  frame.set_resizable(true)
end

def draw
  background(255, 0, 0)
  ellipse(width / 2, height / 2, 100, 50) 
end

