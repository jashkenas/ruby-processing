require 'ruby-processing'

class Conditionals < Processing::App

  def setup
    # Variables
    @r, @g, @b = 150, 0, 0
  end

  def draw
    #Draw stuff
    background @r, @g, @b
    stroke 255
    line width/2, 0, width/2, height
    
    # The following checks use the "ternary operator" which is a compact way
    # of saying, "if this is true ? do this : otherwise this"

    # If the mouse is on the right side of the screen is equivalent to 
    # "if mouse_x is greater than width divided by 2."
    (mouse_x > width/2) ? @r += 1 : @r -=1

    # If r is greater than 255, set it back to 255.  
    # If r is less than 0, set it back to 0.
    @r = 255 if @r > 255
    @r = 0 if @r < 0
   end
   
end

Conditionals.new :title => "Conditionals", :width => 200, :height => 200
