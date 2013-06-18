# A class to describe a Polygon (with a PShape)

class Polygon
  include Processing::Proxy
  # The PShape object
  attr_reader :s, :x, :y, :speed, :height

  def initialize(s_, width, height)
    @x = rand(width)
    @y = rand(-500 .. -100)
    @s = s_
    @speed = rand(2 .. 6)
    @height = height
  end
  
  # Simple motion
  def move
    @y + =speed
    if (y > height + 100)
      @y = -100
    end
  end
  
  # Draw the object
  def display
    push_matrix
    translate(x, y)
    shape(s)
    pop_matrix
  end
  
  def run
    display
    move
  end
end

