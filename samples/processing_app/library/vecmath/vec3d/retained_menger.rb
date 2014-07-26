##########################
# RetainedMenger.rb
# (processing-2.0)
# author Martin Prout
##########################

load_library 'vecmath'

PTS = [-1, 0, 1]
MIN_SIZE = 20

attr_reader :menger

def setup
  size(640, 480, P3D)
  smooth(8)
  ArcBall.init(self)
  @menger = create_shape(GROUP)
  create_menger(0, 0, 0, height * 0.8)
end

def draw
  background(20, 20, 200)
  no_stroke
  lights
  define_light
  render
end

def render
  menger.set_fill(color(224, 223, 219))
  menger.set_ambient(50)
  menger.set_specular(150)
  shape(menger)
end

def create_menger(xx, yy, zz, sz)
  u = sz / 3.0
  if sz < MIN_SIZE # recursion limited by minimum cube size
    no_stroke
    menger.add_child(create_cube(xx, yy, zz, sz)) # create and add a cube
  else
    PTS.each do |i|
      PTS.each do |j|
        PTS.each do |k|
          if (i.abs + j.abs + k.abs) > 1
            create_menger(xx + (i * u), yy + (j * u), zz + (k * u), u)
          end
        end
      end
    end
  end
end

def create_cube(xx, yy, zz, sz)
  dim = sz / 2.0
  cube = create_shape
  cube.begin_shape(QUADS)
  # Front face
  cube.fill(255)
  cube.normal(0, 0, 1)
  cube.vertex(-dim + xx, -dim + yy, -dim + zz)
  cube.vertex(+dim + xx, -dim + yy, -dim + zz)
  cube.vertex(+dim + xx, +dim + yy, -dim + zz)
  cube.vertex(-dim + xx, +dim + yy, -dim + zz)

  # Back face

  cube.normal(0, 0, -1)
  cube.vertex(-dim + xx, -dim + yy, +dim + zz)
  cube.vertex(+dim + xx, -dim + yy, +dim + zz)
  cube.vertex(+dim + xx, +dim + yy, +dim + zz)
  cube.vertex(-dim + xx, +dim + yy, +dim + zz)

  # Left face

  cube.normal(1, 0, 0)
  cube.vertex(-dim + xx, -dim + yy, -dim + zz)
  cube.vertex(-dim + xx, -dim + yy, +dim + zz)
  cube.vertex(-dim + xx, +dim + yy, +dim + zz)
  cube.vertex(-dim + xx, +dim + yy, -dim + zz)

  # Right face

  cube.normal(-1, 0, 0)
  cube.vertex(+dim + xx, -dim + yy, -dim + zz)
  cube.vertex(+dim + xx, -dim + yy, +dim + zz)
  cube.vertex(+dim + xx, +dim + yy, +dim + zz)
  cube.vertex(+dim + xx, +dim + yy, -dim + zz)

  # Top face

  cube.normal(0, 1, 0)
  cube.vertex(-dim + xx, -dim + yy, -dim + zz)
  cube.vertex(+dim + xx, -dim + yy, -dim + zz)
  cube.vertex(+dim + xx, -dim + yy, +dim + zz)
  cube.vertex(-dim + xx, -dim + yy, +dim + zz)

  # Bottom face

  cube.normal(0, -1, 0)
  cube.vertex(-dim + xx, +dim + yy, -dim + zz)
  cube.vertex(+dim + xx, +dim + yy, -dim + zz)
  cube.vertex(+dim + xx, +dim + yy, +dim + zz)
  cube.vertex(-dim + xx, +dim + yy, +dim + zz)
  cube.end_shape
  return cube
end

def define_lights
  ambient_light(50, 50, 50)
  point_light(30, 30, 30, 200, 240, 0)
  directional_light(50, 50, 50, 1, 0, 0)
  spot_light(30, 30, 30, 0, 40, 200, 0, -0.5, -0.5, PI / 2, 2)
end