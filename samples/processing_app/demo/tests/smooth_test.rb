def setup
  size(400, 400, P3D) 
  smooth(2)
end

def draw
  background(255, 0, 0)
  ellipse(mouse_x, mouse_y, 100, 100)  
end

def key_pressed 
  case key
  when '1'
    smooth(1)
  when '2'
    smooth(2)
  when '3'
    smooth(4)
  when '4'
    smooth(8)
  when '5'
    smooth(16)
  when '6'
    smooth(32)
  end
end

