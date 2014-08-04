# Current time can be read with the t = Time.now. Get hour, minute and second 
# using t.hour, t.min, t.sec functions. The processing hour(), minute() and 
# second are deprecated since ruby-processing-2.5.1. In this example, sine and 
# cosine values are used to set the position of the hands.

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
  t = Time.now  # access time from ruby
  stroke 255
  stroke_weight 1
  line( 100, 100, calc_hand_x(t.sec, 0, 72, 100), calc_hand_y(t.sec, 0, 72, 100) )
  stroke_weight 2
  line( 100, 100, calc_hand_x(t.min, t.sec, 60, 100), calc_hand_y(t.min, t.sec, 60, 100) )
  stroke_weight 4
  line( 100, 100, calc_hand_x(t.hour, t.min, 50, 100), calc_hand_y(t.hour, t.min, 50, 100) )
  
  # Draw the minute ticks
  stroke_weight 2
  (0..360).step(6) do |a|
    x = 100 + DegLut.cos(a) * 72
    y = 100 + DegLut.sin(a) * 72
    point x, y
  end
end

# Angles for sin and cos start at 3 o'clock
# subtract 90 degrees to make them start at the top

def calc_hand_x(time, time_bit, length, origin)
  DegLut.cos(time * 6  + time_bit / 10 - 90) * length + origin
end

def calc_hand_y(time, time_bit, length, origin)
  DegLut.sin(time * 6  + time_bit / 10 - 90) * length + origin
end
