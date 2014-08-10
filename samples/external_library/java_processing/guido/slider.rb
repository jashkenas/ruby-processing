load_library :guido
import 'de.bezier.guido'

def setup
  size 400, 400
  Interactive.make self
  @slider = Slider.new  10, height - 20, width - 20, 10
end

def draw
  background 180
  fill 255
  v = 10 + @slider.value * (width - 30)
  ellipse width / 2, height / 2, v, v
end

class Slider < ActiveElement
  
  attr_reader :value
  
  def initialize (x, y, w, h)
    super x, y, w, h
    @x = x
    @y = y
    @width = w
    @height = h
    @hover = false
    @value = 0
    @value_x = x
  end
  
  def mouseEntered(mx, my)
    @hover = true
  end
  
  def mouseExited(mx, my)
    @hover = false
  end
  
  def mouseDragged(mx, my, dx, dy)
    @value_x = mx - @height / 2    
    @value_x = @x if (@value_x < @x) 
    @value_x = @x + @width - @height if (@value_x > @x + @width - @height)    
    @value = map(@value_x, @x, @x + @width - @height, 0, 1)
  end
  
  def draw
    no_stroke
    fill @hover ? 220 : 150
    rect @x, @y, @width, @height
    fill 120
    rect @value_x, @y, @height, @height
  end
end 