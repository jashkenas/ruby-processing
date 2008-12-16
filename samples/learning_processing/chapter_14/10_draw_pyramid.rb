require 'ruby-processing'

class DrawPyramidSketch < Processing::App

  def setup
    render_mode P3D
    @theta = 0.0
  end

  def draw
    background 255
    @theta += 0.01

    translate 100, 100, 0
    rotate_x @theta
    rotate_y @theta
    draw_pyramid 50

    # translate the scene again
    translate 50, 50, 20
    # call the pyramid drawing function
    draw_pyramid 10
  end

  def draw_pyramid(t)
    stroke 0

    # this pyramid has 4 sides, each drawn as a separate triangle
    # each side has 3 vertices, making up a triangle shape
    # the parameter "t" determines the size of the pyramid
    begin_shape TRIANGLES

    fill 150, 0, 0, 127
    vertex -t, -t, -t
    vertex  t, -t, -t
    vertex  0,  0,  t

    fill 0, 150, 0, 127
    vertex  t, -t, -t
    vertex  t,  t, -t
    vertex  0,  0,  t

    fill 0, 0, 150, 127
    vertex  t,  t, -t
    vertex -t,  t, -t
    vertex  0,  0,  t

    fill 150, 0, 150, 127
    vertex -t,  t, -t
    vertex -t, -t, -t
    vertex  0,  0,  t

    end_shape 
  end

end


DrawPyramidSketch.new :title => "Draw Pyramid",  :width => 200,  :height => 200
