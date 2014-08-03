# The current local time can be read with the Time.now
# the seconds Time.now.sec, minutes Time.now.min etc...
# functions. In this example, DegLut.sin() and DegLut.cos() values are used to
# set the position of the hands, perfect for degree precision Lookup Table.
load_library :fastmath

def setup
  size 200, 200
  stroke 255
  smooth 8
end

def draw
  background 0
  fill 80
  no_stroke
  # adj factor to map 0-60 to 0-360 (sec/min) & 0-12 to 0-360 (hours)
  # since angles for DegLut.sin() and DegLut.cos() start at 3 o'clock we
  # subtract 90 degrees to make them start at the top.
  clock_x = lambda do |val, adj, length|
    DegLut.cos((val * adj).to_i - 90) * length + width / 2
  end
  clock_y = lambda do |val, adj, length|
    DegLut.sin((val * adj).to_i - 90) * length + height / 2
  end
  ellipse 100, 100, 160, 160
  stroke 220
  stroke_weight 6
  t = Time.now
  line(100, 100, clock_x.call(t.hour % 12 + (t.min / 60.0), 30, 50),
                 clock_y.call(t.hour % 12 + (t.min / 60.0), 30, 50))
  stroke_weight 3
  line(100, 100, clock_x.call(t.min + (t.sec / 60.0), 6, 60),
                 clock_y.call(t.min + (t.sec / 60.0), 6, 60))
  stroke 255, 0, 0
  stroke_weight 1
  line(100, 100, clock_x.call(t.sec, 6, 72), clock_y.call(t.sec, 6, 72))
  # Draw the minute ticks
  stroke_weight 2
  stroke 255
  (0..360).step(6) do |a|
    x = 100 + DegLut.cos(a) * 72
    y = 100 + DegLut.sin(a) * 72
    point x, y
  end
end
