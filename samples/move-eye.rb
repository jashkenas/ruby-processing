require 'ruby-processing'

class MoveEye < Processing::App
  load_java_library "opengl"

  def setup
    render_mode OPENGL
    fill 204
  end

  def draw
    lights
    background 0
    camera(mouse_x, mouse_y, 220.0,
      0.0, 0.0, 0.0,
      0.0, 1.0, 0.0)
    no_stroke
    box 90
    stroke 255
    line -100, 0, 0, 100, 0, 0
    line 0, -100, 0, 0, 100, 0
    line 0, 0, -100, 0, 0, 100
  end
end

MoveEye.new