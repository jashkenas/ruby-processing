# From the Processing Examples
# Uses the "bare" style, where a Processing::App sketch is implicitly wrapped
# around the code.
# -- omygawshkenas

FRAME_COUNT = 12

def setup
  @frames         = []
  @last_time      = 0
  @current_frame  = 0
  @draw           = false
  @back_color     = 204
  size 350, 350
  stroke_weight 4
  smooth
  background @back_color
  FRAME_COUNT.times { @frames << get() }
end

def draw
  time = millis()
  if time > @last_time + 100
    next_frame
    @last_time = time
  end
  line(pmouse_x, pmouse_y, mouse_x, mouse_y) if @draw
end

def mouse_pressed; @draw = true; end
def mouse_released; @draw = false; end

def key_pressed
  background @back_color
  @frames.size.times {|i| @frames[i] = get()}
end

def next_frame
  @frames[@current_frame] = get()
  @current_frame += 1
  @current_frame = 0 if @current_frame >= @frames.size
  image(@frames[@current_frame], 0, 0)
end