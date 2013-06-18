# Many PDFs. 
# 
# Saves one PDF file each each frame while the mouse is pressed.
# When the mouse is released, the PDF creation stops.
#

load_library 'pdf'
include_package 'processing.pdf'

attr_reader :pdf, :save_pdf

def setup
  size(600, 600)
  frameRate(24)
  @save_pdf = false
end

def draw
  begin_record(PDF, "lines#{frame_count}.pdf") unless !save_pdf
  background(255) 
  stroke(0, 20)
  stroke_weight(20.0)
  line(mouse_x, 0, width-mouse_y, height)
  end_record unless !save_pdf
end

def mouse_pressed
  @save_pdf = true
end

def mouse_released
  @save_pdf = false
end




