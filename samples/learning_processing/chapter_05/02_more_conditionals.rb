require 'ruby-processing'

class MoreConditionals < Processing::App

  def setup
    # Three variables for the background color.
    @r, @g, @b = 0, 0, 0
  end

  def draw
    # Color the background and draw lines to divide the window in quadrants.
    background @r, @g, @b
    stroke 0
    line width/2, 0, width/2, height
    line 0, height/2, width, height/2
    
    # The following checks use the "ternary operator" which is a compact way
    # of saying, "if this is true ? do this : otherwise this"
    
    # If the mouse is on the right hand side of the window, increase red.  
    # Otherwise, it is on the left hand side and decrease red.
    (mouse_x > width / 2) ? @r += 1 : @r -= 1
    
    # If the mouse is on the bottom of the window, increase blue.  
    # Otherwise, it is on the top and decrease blue.
    (mouse_y > height/2) ? @b += 1 : @b -= 1
    
    # If the mouse is pressed. (for green)
    mouse_pressed? ? @g += 1 : @g -= 1
    
    # Constrain all color values to between 0 and 255.
    @r = constrain(@r, 0, 255)
    @g = constrain(@g, 0, 255)
    @b = constrain(@b, 0, 255)
  end
end

MoreConditionals.new :title => "More Conditionals", :width => 200, :height => 200