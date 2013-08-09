def setup
  size(300, 300, P2D)
  frame_rate(10)
end

def draw  
  if frame_count == 3
    puts "ok"
    exit
  end
end
