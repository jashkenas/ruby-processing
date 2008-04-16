
# ruby port of the Processing 'Recursion2' sample script  --rickbradley

require 'ruby-processing'

class Sketch < Processing::App
  load_java_library :opengl
  
  attr_accessor :x_wiggle, :y_wiggle, :magnitude, :bluish
  
  def setup
    library_loaded?(:opengl) ? render_mode(OPENGL) : render_mode(P3D)
    no_stroke
    smooth
    draw_circle(100, 100, 80, 8)
  end
  
  def draw_circle(x, y, radius, level)
    tt = 126.0 * level/6.0
    fill(tt, 153)
    ellipse(x, y, radius*2, radius*2)
    if level > 1
      level -= 1
      num = rand(5)+1
      1.upto(num) do
        a = rand(2*Math::PI)
        nx = x + Math.cos(a) * 6.0 * level
        ny = y + Math.sin(a) * 6.0 * level
        draw_circle(nx, ny, radius/2, level)
      end
    end
  end
end

Sketch.new(:width => 200, :height => 200, :title => "Recursion2", :full_screen => false)
