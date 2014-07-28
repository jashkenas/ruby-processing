# One Frame. 
# 
# Saves one PDF with the contents of the display window.
# Because this example uses beginRecord, the image is shown
# on the display window and is saved to the file.  

load_library 'pdf'
include_package 'processing.pdf'

def setup
  size(600, 600)    
  begin_record(PDF, "line.pdf")     
  background(255)
  stroke(0, 20)
  strokeWeight(20.0)
  line(200, 0, 400, height)    
  end_record
end

