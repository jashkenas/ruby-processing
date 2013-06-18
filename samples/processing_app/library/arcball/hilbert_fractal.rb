########################################################
# A 3D Hilbert fractal implemented using a
# Lindenmayer System in ruby-processing by Martin Prout
# Demonstrates arcball rotation hold down z, y or z key
# to constrain to that axis of rotation. Otherwise get
# intuitive rotation with dragged mouse.
########################################################

load_libraries 'hilbert', 'arcball'
import 'arcball'
attr_reader :hilbert, :arcball

def setup
  size 1024, 768, P3D
  @arcball = ArcBall.new(width/2.0, height/2.0, min(width - 20, height - 20) * 0.5)
  @hilbert = Hilbert.new(height/2, 3)
  no_stroke
end

def draw
  background 0
  translate(width/2.0, height/2.0) 
  update
  lights
  define_lights
  ambient(40)
  specular(15)
  hilbert.render
end

def update
  theta, x, y, z = arcball.update
  rotate(theta, x, y, z)
end

def mouse_pressed
  arcball.mouse_pressed(mouse_x, mouse_y)
end

def mouse_dragged
  arcball.mouse_dragged(mouse_x, mouse_y)
end

def define_lights
  ambient(20, 20, 20)
  ambient_light(60, 60, 60)
  point_light(30, 30, 30, 0, 0, 0)
  directional_light(40, 40, 50, 1, 0, 0)
  spot_light(30, 30, 30, 0, 40, 200, 0, -0.5, 0.5, PI / 2, 2)
end

def key_pressed                
  case(key)
when 'x'
  arcball.select_axis(X)
when 'y'
  arcball.select_axis(Y)
when 'z'
  arcball.select_axis(Z)
end
end

def key_released
  arcball.select_axis(-1)
end
