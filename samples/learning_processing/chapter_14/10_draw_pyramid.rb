require 'ruby-processing'

class DrawPyramidSketch < Processing::App

  def setup
    @theta = 0.0
    size 400, 400, P3D
  end

  def draw
    background 255
    @theta += 0.01

    translate 200, 200, 0
    rotateX @theta
    rotateY @theta
    draw_pyramid 100

    # translate the scene again
    translate 100, 100, 40
    # call the pyramid drawing function
    draw_pyramid 20
  end

  def draw_pyramid(t)
    stroke 0

    # this pyramid has 4 sides,  each drawn as a separate triangle
    # each side has 3 vertices,  making up a triangle shape
    # the parameter " t " determines the size of the pyramid
    beginShape TRIANGLES

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

    endShape 
  end

end


DrawPyramidSketch.new :title => "Draw Pyramid",  :width => 400,  :height => 400
