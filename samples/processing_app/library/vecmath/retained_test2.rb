load_library 'vecmath'

attr_reader :my_cube

def setup
  size(600, 600, P3D)
  smooth(16)
  ArcBall.new(self)
  @my_cube = create_shape(BOX, 400, 400, 400)
  my_cube.set_fill(color(100, 10, 100))

end

def draw
  background(50, 50, 100)
  define_lights
  lights
  stroke(0)
  shape(my_cube)
end

def define_lights
  ambient(20, 20, 20)
  ambient_light(50, 50, 50)
  point_light(30, 30, 30, 200, -150, 0)
  directional_light(0, 30, 50, 1, 0, 0)
  spot_light(30, 30, 30, 0, 40, 200, 0, -0.5, -0.5, PI / 2, 2)
end

