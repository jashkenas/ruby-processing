# One Frame. 
# 
# Large Page. 
# 
# Saves one frame as a PDF with a size larger
# than the screen. When PDF is used as the renderer
# (the third parameter of size) the display window 
# does not open. The file is saved to the sketch folder.

load_libraries 'pdf'
include_package 'processing.pdf'

def setup
    size(2000, 2000, PDF, "Line.pdf")  
end

def draw
  background(255)
  stroke(0, 20)
  strokeWeight(20.0);
  line(200, 0, width/2, height)  
  exit  # Quit the program
end


