require 'ruby-processing'

class RotateAllSketch < Processing::App

  def setup
    render_mode P3D
    rect_mode CENTER
  end

  def draw
    background 255
    stroke 0
    fill 175

    translate width/2, height/2
    rotate_x PI * mouse_x / height
    rotate_y PI * mouse_x / height
    rect 0, 0, 100, 100
  end

end

RotateAllSketch.new :title => "Rotate All",  :width => 200,  :height => 200

