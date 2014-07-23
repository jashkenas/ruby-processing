java_alias :background_int, :background, [Java::int]

def setup
  size(300, 300)
  frame_rate(10)
end

def draw
  background_int 0
  if frame_count == 3
    puts 'ok'
    exit
  end
end
