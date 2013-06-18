#
# Brownian motion. 
# 
# Recording random movement as a continuous line. 
#

NUM = 2000
RANGE = 6

attr_accessor :ax, :ay 

def setup   
  size(640, 360)
  @ax = Array.new(NUM, width/2)
  @ay = Array.new(NUM, height/2)
  frame_rate(30)
end

def draw   
  background(51)  
  # Shift all elements 1 place to the left
  (1 ... NUM).each do |i|
    ax[i-1] = ax[i]
    ay[i-1] = ay[i]
  end  
  # Put a new value at the end of the array
  ax[NUM-1] += rand(-RANGE .. RANGE)
  ay[NUM-1] += rand(-RANGE .. RANGE)
  
  # Constrain all points to the screen
  ax[NUM-1] = constrain(ax[NUM-1], 0, width)
  ay[NUM-1] = constrain(ay[NUM-1], 0, height)
  
  # Draw a line connecting the points
  (1 ... NUM).each do |i|
    val = i.to_f / NUM * 204.0 + 51
    stroke(val)
    line(ax[i-1], ay[i-1], ax[i], ay[i])
  end
end
