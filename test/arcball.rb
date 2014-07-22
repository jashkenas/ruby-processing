load_library :vecmath

def setup
  size(300, 300, P3D)
  ArcBall.init(self)
  frame_rate(10)
end

def draw
  background 39, 232, 51
  if frame_count == 3
    puts 'ok'
    exit
  end
end
