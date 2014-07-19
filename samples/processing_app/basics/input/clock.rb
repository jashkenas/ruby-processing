# The current time can be read with the second(), minute(), 
# and hour() functions. In this example, sin() and cos() values
# are used to set the position of the hands.
load_library :fastmath

def setup
  size 200, 200
  stroke 255
  smooth 4
end

def draw
  background 0
  fill 80
  no_stroke 

  ellipse 100, 100, 160, 160 
  
  stroke 255
  stroke_weight 1
  line( 100, 100, calc_hand_x(second, 0, 72, 100), calc_hand_y(second, 0, 72, 100) )
  stroke_weight 2
  line( 100, 100, calc_hand_x(minute, second, 60, 100), calc_hand_y(minute, second, 60, 100) )
  stroke_weight 4
  line( 100, 100, calc_hand_x(hour, minute, 50, 100), calc_hand_y(hour, minute, 50, 100) )
  
  # Draw the minute ticks
  stroke_weight 2
  (0..360).step(6) do |a|
    x = 100 + DegLut.cos(a) * 72
    y = 100 + DegLut.sin(a) * 72
    point x, y
  end
end

# Angles for sin() and cos() start at 3 o'clock;
# subtract 90 degrees to make them start at the top

def calc_hand_x(time, time_bit, length, origin)
  DegLut.cos(time * 6  + time_bit / 10 - 90) * length + origin
end

def calc_hand_y(time, time_bit, length, origin)
  DegLut.sin(time * 6  + time_bit / 10 - 90) * length + origin
end
