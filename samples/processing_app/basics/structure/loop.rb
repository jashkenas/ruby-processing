# No Loop.
#
# The noLoop() function causes draw() to only
# execute once. Without calling noLoop(), draw()
# executed continually.
attr_reader :y, :clicked

def setup
  size 640, 360
  @y = height / 2
  stroke 255
  frame_rate 30
  @clicked = true
end

def draw
  background 0
  @y = y - 1
  @y = height if y < 0
  line 0, y, width, y
end

def mouse_pressed
  unless clicked
    no_loop
  else
    loop
  end
  @clicked = !clicked
end
