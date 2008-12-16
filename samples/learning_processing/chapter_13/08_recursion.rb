require 'ruby-processing'

class RecursionSketch < Processing::App

  def setup
    smooth
  end

  def draw
    background 255
    stroke 0
    no_fill

    draw_circle width/2, height/2, width/2
  end

  def draw_circle(x, y, radius)
    ellipse x, y, radius, radius
    # It's important to establish an end-point to recursion, or else it 
    # would go forever. Comment out the following line to break the sketch.
    return if radius < 2
    # draw_circle calls itself twice, creating a branching effect. 
    # For every circle, a smaller circle is drawn to the left and right.
    draw_circle x+radius/2, y, radius/2
    draw_circle x-radius/2, y, radius/2
  end

end

RecursionSketch.new :title => "Recursion", :width => 200, :height => 200
