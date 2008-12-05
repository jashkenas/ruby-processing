require 'ruby-processing'

class ButtonAsSwitch < Processing::App

  def setup
    @x, @y = 50, 50
    @w, @h = 100, 75
    @button = false
  end
  
  def draw
    if @button
      background 255
      stroke 0
    else
      background 0
      stroke 255
    end
    
    fill 175
    rect @x, @y, @w, @h
  end
  
  # When the mouse is pressed, the state of the button is toggled.   
  # Try moving this code to draw() like in the rollover example. What goes wrong?
  def mouse_pressed
    if mouse_x > @x && mouse_x < @x+@w && mouse_y > @y && mouse_y < @y+@h
      @button = !@button 
    end
  end

end

ButtonAsSwitch.new :title => "Button As Switch", :width => 200, :height => 200