# A Bubble class

class Bubble
  include Processing::Proxy
  
  attr_reader :x, :y, :diameter, :name, :over
  
  # Create  the Bubble
  def initialize(x, y, diameter, name)
    @x = x
    @y = y
    @diameter = diameter
    @name = name
    @over = false
  end
  
  # Checking if mouse is over the Bubble
  def rollover(px, py)
    d = dist(px,py,x,y)
    @over = (d < diameter/2)? true : false
  end
  
  # Display the Bubble
  def display
    stroke(0)
    stroke_weight(2)
    noFill
    ellipse(x,y,diameter,diameter)
    if (over)
      fill(0)
      text_align(CENTER)
      text(name, x, y + diameter/2 + 20)
    end
  end
end
