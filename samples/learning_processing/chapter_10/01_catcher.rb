require 'ruby-processing'

class CatcherSketch < Processing::App
  def setup
    @catcher = Catcher.new(32)
    smooth
  end
  
  def draw
    background 255
    @catcher.set_location mouse_x, mouse_y
    @catcher.display
  end
end


class Catcher
  def initialize(temp_r)
    @r = temp_r
    @x, @y = 0, 0
  end
  
  def set_location(temp_x, temp_y)
    @x, @y = temp_x, temp_y
  end
  
  # In Ruby-Processing, you can always find the sketch in $app.
  def display
    $app.stroke 0
    $app.fill 175
    $app.ellipse @x, @y, @r*2, @r*2
  end
end

CatcherSketch.new :title => "CatcherSketch", :width => 400, :height => 400