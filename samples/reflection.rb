# Taken from the Processing Examples.

require 'ruby-processing'

class Reflection < Processing::App
  
  def setup
    render_mode(P3D)
    no_stroke
    color_mode(RGB, 1)
    fill 0.4
  end
  
  def draw
    background 0
    translate( width/2, height/2 )
    light_specular(1, 1, 1)
    directional_light(0.8, 0.8, 0.8, 0, 0, -1)
    s = mouse_x.to_f / width.to_f
    specular s, s, s
    sphere 50
  end
  
end

Reflection.new(:width => 200, :height => 200, :title => "Reflection")