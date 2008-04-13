# This full screen OpenGL demo requires Processing's
# OpenGL library. Copy that into ruby-processing/library, 
# and this'll work fine.
# However, native libs like OpenGL are not yet
# supported in applets.

require 'ruby-processing'

class FullScreen < Processing::App
  load_java_library "opengl"
  
  def setup
    render_mode OPENGL
    no_stroke
  end
  
  def draw
    lights
    background 0
    fill 120, 160, 220
    (width/100).times do |x|
      (height/100).times do |y|
        new_x, new_y = x * 100, y * 100
        push_matrix
        translate new_x, new_y
        rotate_y(((mouse_x.to_f + new_x) / width) * Math::PI)
        rotate_x(((mouse_y.to_f + new_y) / height) * Math::PI)
        box 90
        pop_matrix
      end
    end
  end
end

FullScreen.new(:full_screen => false)