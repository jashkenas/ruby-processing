require 'ruby-processing'

class HoldDownTheButton < Processing::App

  def setup
    @x, @y = 50, 50
    @w, @h = 100, 75
  end
  
  def draw
    # The button is pressed if (mouse_x, mouse_y) is inside
    # the rectangle and mouse_pressed? is true.
    if mouse_x > @x && mouse_x < @x+@w && mouse_y > @y && mouse_y < @y+@h && mouse_pressed?
      button = true
    else
      button = false
    end
    
    if button
      background 255
      stroke 0
    else
      background 0
      stroke 255
    end
    
    fill 175
    rect @x, @y, @w, @h
  end
    
end

HoldDownTheButton.new :title => "Hold Down The Button", :width => 200, :height => 200