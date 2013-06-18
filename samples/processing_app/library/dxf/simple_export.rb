# Simple DXF Export
# by Simon Greenwold. 
# 
# Press the 'R' key to export a DXF file.
#

load_library 'dxf'
include_package 'processing.dxf'

attr_reader :recording

def setup
  size(400, 400, P3D)
  noStroke
  sphereDetail(12)
  @recording = false
end

def draw
  begin_raw(DXF, "output.dxf") if recording # Start recording to the file
  lights
  background(0)
  translate(width / 3, height / 3, -200)
  rotate_z(map(mouse_y, 0, height, 0, PI))
  rotateY(map(mouse_x, 0, width, 0, HALF_PI))
  (-2 .. 2).step do |y|
    (-2 .. 2).step do |x| 
      (-2 .. 2).step do |z|
        push_matrix
        translate(120*x, 120*y, -120*z)
        sphere(30)
        pop_matrix
      end
    end
  end
  end_raw if recording
  @recording = false # Stop recording to the file
end  

def key_pressed
  if (key == 'R' || key == 'r') # Press R to save the file
    @recording = true
  end
end
  
  
  

