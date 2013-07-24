#
# Star
# 
# The star function created for this example is capable of drawing a
# wide range of different forms. Try placing different numbers into the 
# star function calls within draw to explore. 
#

def setup
  size(640, 360)
end

def draw
  background(102)
  
  push_matrix
  translate(width*0.2, height*0.5)
  rotate(frame_count / 200.0)
  star(0, 0, 5, 70, 3) 
  pop_matrix
  
  push_matrix
  translate(width*0.5, height*0.5)
  rotate(frame_count / 50.0)
  star(0, 0, 80, 100, 40) 
  pop_matrix
  
  push_matrix
  translate(width*0.8, height*0.5)
  rotate(frame_count / -100.0)
  star(0, 0, 30, 70, 5) 
  pop_matrix
end

def star(x, y, radius1, radius2, npoints)
  angle = TWO_PI / npoints
  half_angle = angle/2.0
  begin_shape
  (0 .. TWO_PI).step(angle) do |a|
    sx = x + cos(a) * radius2
    sy = y + sin(a) * radius2
    vertex(sx, sy)
    sx = x + cos(a + half_angle) * radius1
    sy = y + sin(a + half_angle) * radius1
    vertex(sx, sy)
  end
  end_shape(CLOSE)
end
