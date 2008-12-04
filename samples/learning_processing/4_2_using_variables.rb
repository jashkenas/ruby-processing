require 'ruby-processing'

class UsingVariables < Processing::App

  def setup
    # Create two variables, holding integers.
    # These will be instance variables, meaning that you can
    # get at them from any method within this class.
    # Instance variables in Ruby begin with '@'.
    
    @circle_x = 100
    @circle_y = 100
    smooth
  end
  
  def draw
    background 255
    stroke 0
    fill 175
    # We use the instance variables from setup for the circle.
    # They are available in this method too.
    ellipse @circle_x, @circle_y, 50, 50
  end
  
end

UsingVariables.new :title => "Using Variables", :width => 200, :height => 200