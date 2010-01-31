load_library 'PeasyCam'
import 'peasy'

attr_reader :cam

def setup
  size 200, 200, P3D
  configure_camera
end

def configure_camera
  @cam = PeasyCam.new(self, 100)
  cam.set_minimum_distance 50
  cam.set_maximum_distance 500
end

def draw
  rotate_x -0.5
  rotate_y -0.5
  background 0
  fill 255, 0, 0
  box 30
  push_matrix
  translate 0, 0, 20
  fill 0, 0, 255
  box 5
  pop_matrix
end

