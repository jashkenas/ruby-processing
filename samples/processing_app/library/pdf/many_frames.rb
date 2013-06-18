# Multiple Frames. 
# 
# Saves one PDF document of many frames drawn to the screen.
# Starts the file when the mouse is pressed and end the file
# when the mouse is released.


load_library 'pdf'
include_package 'processing.pdf'

def setup
  size(600, 600)
  frame_rate(24)
  background(255)
end

def draw
  stroke(0, 20)
  stroke_weight(20.0)
  line(mouse_x, 0, width-mouse_y, height)
end


def mouse_pressed
  begin_record(PDF, "Lines.pdf"); 
  background(255);
end

def mouse_released
  end_record
  background(255)
end

