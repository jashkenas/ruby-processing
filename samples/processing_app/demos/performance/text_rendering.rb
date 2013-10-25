def setup
  size(800, 600, P2D)
  fill(0)
end

def draw     
  background(255)
  (0 .. 10000).each do
    x = rand(width)
    y = rand(height)
    text("HELLO", x, y)
  end
  puts(frame_rate) if (frame_count % 10) == 0
end
