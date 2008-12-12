require 'ruby-processing'

class SimpleRaindrop < Processing::App

  def setup
    background 0
    @x, @y = width / 2, 0
    smooth
    no_stroke
  end
  
  def draw
    background 255
    # Show the drop
    fill 50, 100, 150
    ellipse @x, @y, 16, 16
    # Move the drop
    @y += 1
  end
  
end

SimpleRaindrop.new :title => "Simple Raindrop", :width => 400, :height => 400