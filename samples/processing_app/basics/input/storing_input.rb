#
# Storing Input. 
# 
# Move the mouse across the screen to change the position
# of the circles. The positions of the mouse are recorded
# into an array and played back every frame. Between each
# frame, the newest value are added to the end of each array
# and the oldest value is deleted. 
#
 
NUM = 60
X = 0
Y = 1

attr_reader :pos

def setup  
  size(640, 360)
  @pos = Array.new(NUM, Array.new(2, 0))  # initialize a nested array
  smooth(4)
  noStroke()
  fill(255, 153) 
end

def draw
  background(51) 
  
  # Cycle through the array, using a different entry on each frame. 
  # Using modulo (%) like this is faster than moving all the values over.
  which = frame_count % NUM
  pos[which] = [mouse_x, mouse_y]
  
  (1 .. NUM).each do |i|
    # which + 1 is the smallest (the oldest in the array)
    idx = (which + i) % NUM
    ellipse(pos[idx][X], pos[idx][Y], i, i)
  end
end
