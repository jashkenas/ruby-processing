load_library :vecmath

def setup
  size(300, 300)
  a = Vec2D.new(1.0, 1.0)
  b = Vec2D.new(1.0, 1.0)
  (a == b )? puts('ok') : puts('fail')
  exit
end

