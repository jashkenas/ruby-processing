# Description:
# Flight Patterns is that ol' Euruko 2008 demo.

full_screen
load_libraries 'boids', 'opengl'
import "processing.opengl" if library_loaded? "opengl"

def setup
  library_loaded?(:opengl) ? setup_opengl : render_mode(P3D)
  sphere_detail 8
  color_mode RGB, 1.0
  no_stroke
  frame_rate 30
  shininess 1.0
  specular 0.3, 0.1, 0.1
  emissive 0.03, 0.03, 0.1
  
  @click = false
  @flocks = []
  3.times do |i|
    flock = Boids.flock 20, 0, 0, width, height
    flock.goal width/2, height/2, 0
    @flocks << flock
  end
end

def setup_opengl
  render_mode(OPENGL)
  hint ENABLE_OPENGL_4X_SMOOTH
end

def mouse_pressed
  @click = !@click
end

def draw
  background 0.05
  ambient_light 0.01, 0.01, 0.01
  light_specular 0.4, 0.2, 0.2
  point_light 1.0, 1.0, 1.0, mouse_x, mouse_y, 190
  @flocks.each_with_index do |flock, i|
    flock.goal mouse_x, mouse_y, 0, @flee
    flock.update(:goal => 185, :limit => 13.5)
    for boid in flock do
      r = 20 + (boid.z * 0.15)
      alpha = 0.5 + (boid.z * 0.01)
      case i
      when 0 then fill 0.55, 0.35, 0.35
      when 1 then fill 0.35, 0.55, 0.35
      when 2 then fill 0.35, 0.35, 0.55
      end
      push_matrix
      translate boid.x-r/2, boid.y-r/2, boid.z-r/2
      @click ? sphere(r/2) : oval(0, 0, r, r)
      pop_matrix
    end
  end
end
