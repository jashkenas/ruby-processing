# fibonacci_sphere.rb
# After a vanilla processing sketch by Jim Bumgardner
# http://www.openprocessing.org/sketch/41142
#
# Controls:
# 1. drag mouse to rotate sphere (uses builtin arcball library)
# 2. click mouse to toggle add box to sphere surface
# 3. press x, y, or z to constrain arcball rotation to that axis
#

load_library :arcball
import "arcball"

X = 0
Y = 1
Z = 2

PHI = (sqrt(5)+1) / 2 - 1   # golden ratio
GA = PHI * TWO_PI           # golden angle

KMAX_POINTS = 100000

attr_reader :pts, :rotation_x, :rotation_y, :nbr_points, :radius, :add_points
attr_reader :my_ball # for arcball rotation

def setup
  size(1024, 768, P3D)
  @my_ball = ArcBall.new(width/2.0, height/2.0, min(width - 20, height - 20) * 0.5)
  @rotation_x = 0
  @rotation_y = 0
  @nbr_points = 2000
  @radius = 0.8 * height / 2
  @add_points = true
  @pts = Array.new(KMAX_POINTS)
  init_sphere(nbr_points)
  background(0)
end

def draw    
  if add_points 
    @nbr_points += 1
    @nbr_points = min(nbr_points, KMAX_POINTS)
    init_sphere(nbr_points)
  end
  
  background 0            
  lights
  ambient(200, 10, 10)
  ambient_light(150, 150, 150)
  translate(width/2.0, height/2.0, 0)
  update  # for arcball rotation
  render_globe   
end

# arcball functionality ##################
##########################################

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
###########################################
# For Fibonacci Sphere
##################################

def render_globe
  push_matrix
  (0 .. min(nbr_points, pts.length)).each do |i|    
    lat = pts[i].lat 
    lon = pts[i].lon    
    push_matrix
    rotate_y(lon)
    rotate_z(-lat)
    fill(200, 10, 10)
    translate(radius, 0, 0)
    box(4, 7, 7)
    pop_matrix
  end
  pop_matrix  
end

def mouse_clicked
  @add_points = !add_points
end

SpherePoint = Struct.new(:lat, :lon) do
end

def init_sphere(num)  
  (0 .. num).each do |i| 
    lon = GA * i
    lon /= TWO_PI 
    lon -= lon.floor 
    lon *= TWO_PI 
    if (lon > PI)
      lon -= TWO_PI
    end    
    # Convert dome height (which is proportional to surface area) to latitude
    # lat = asin(-1 + 2 * i / num.to_f)    
    pts[i] = SpherePoint.new(asin(-1 + 2 * i / num.to_f), lon)
  end
end
