load_library 'arcball'
import "arcball"

X = 0
Y = 1
Z = 2

attr_reader :my_ball, :my_cube

def setup
  size(600, 600, P3D)
  smooth(16)
  @my_ball = ArcBall.new(width/2.0, height/2.0, min(width - 20, height - 20) * 0.5)
  @my_cube = create_shape(BOX, my_ball.radius, my_ball.radius, my_ball.radius)
  my_cube.set_fill(color(100, 10, 100))

end

def draw
  background(50, 50, 100)
  translate(width/2.0, height/2.0)  # @todo add zoom via z, using control_panel
  define_lights
  update
  lights
  stroke(0)
  shape(my_cube)
end

def update
  theta, x, y, z = my_ball.update
  rotate(theta, x, y, z)
end

def mouse_pressed
  my_ball.mouse_pressed(mouse_x, mouse_y)
end

def mouse_dragged
  my_ball.mouse_dragged(mouse_x, mouse_y)
end

def define_lights
  ambient(20, 20, 20)
  ambient_light(50, 50, 50)
  point_light(30, 30, 30, 200, -150, 0)
  directional_light(0, 30, 50, 1, 0, 0)
  spot_light(30, 30, 30, 0, 40, 200, 0, -0.5, -0.5, PI / 2, 2)
end

def key_pressed                
  case(key)
  when 'x'
    my_ball.select_axis(X)
  when 'y'
    my_ball.select_axis(Y)
  when 'z'
    my_ball.select_axis(Z)
  end
end

def key_released
  my_ball.select_axis(-1)
end


