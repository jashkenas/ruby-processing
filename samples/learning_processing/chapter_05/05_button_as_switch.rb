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
  
  # The following method uses Ruby ranges, which look like 1..10, and
  # stand for the range of things between the start and end element.
  # You can ask a range if it includes a value, in this case whether
  # or not mouse_x is between @x and @x+@w.
  def mouse_pressed
    if (@x..@x+@w).include?(mouse_x) && (@y..@y+@h).include?(mouse_y)
      @button = !@button 
    end
  end

end

ButtonAsSwitch.new :title => "Button As Switch", :width => 200, :height => 200