# Drawolver: draw 2D & revolve 3D

# Example shows how to use the vecmath library, including AppRender utility.
# On the ruby side features the use each_cons, a possibly a rare use for this
# ruby Enumerable method?
# 2010-03-22 - fjenett (somewhat revised by Martin Prout 2014-07-06)

load_library :vecmath, :fastmath

attr_reader :drawing_mode, :points, :rot_x, :rot_y, :vertices, :renderer

def setup
  size 1024, 768, P3D
  @renderer = AppRender.new(self)
  frame_rate 30
  reset_scene
end

def draw
  background 0
  unless drawing_mode
    translate(width / 2, height / 2)
    rotate_x rot_x
    rotate_y rot_y
    @rot_x += 0.01
    @rot_y += 0.02
    translate(-width / 2, -height / 2)
  end
  no_fill
  stroke 255
  points.each_cons(2) { |ps, pe| line ps.x, ps.y, pe.x, pe.y }
  unless drawing_mode
    stroke 125
    fill 120
    lights
    ambient_light 120, 120, 120
    vertices.each_cons(2) do |r1, r2|
      begin_shape(TRIANGLE_STRIP)
      r1.zip(r2).each do |v1, v2|
        v1.to_vertex(renderer)
        v2.to_vertex(renderer)
      end
      end_shape
    end
  end
end

def reset_scene
  @drawing_mode = true
  @points = []
  @rot_x = 0.0
  @rot_y = 0.0
end

def mouse_pressed
  reset_scene
  points << Vec3D.new(mouse_x, mouse_y)
end

def mouse_dragged
  points << Vec3D.new(mouse_x, mouse_y)
end

def mouse_released
  points << Vec3D.new(mouse_x, mouse_y)
  recalculate_shape
end

def recalculate_shape
  @vertices = []
  points.each_cons(2) do |ps, _pe_|
    b = (points.last - points.first).normalize!
    a = ps - points.first
    dot_product = a.dot b
    b *= dot_product
    normal = points.first + b
    c = ps - normal
    vertices << []
    (0..360).step(12) do |ang|
      e = normal + c * DegLut.cos(ang)
      e.z = c.mag * DegLut.sin(ang)
      vertices.last << e
    end
  end
  @drawing_mode = false
end