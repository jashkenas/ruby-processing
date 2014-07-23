java_alias :background_float_float_float, :background, [Java::float, Java::float, Java::float]

def setup
  size(300, 300, P3D)
  frame_rate(10)
end

def draw
  background_float_float_float 39, 232, 51
  if frame_count == 3
    puts 'ok'
    exit
  end
end
