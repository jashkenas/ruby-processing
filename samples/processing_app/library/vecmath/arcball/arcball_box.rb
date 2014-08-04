load_library :vecmath

############################
# Use mouse drag to rotate
# the arcball. Use mousewheel
# to zoom. Hold down x, y, z
# to constrain rotation axis.
############################

def setup
  size(600, 600, P3D)
  smooth(8)
  ArcBall.init(self, 300, 300)
  fill 180
end

def draw
  background(50)  
  box(300, 300, 300)
end



