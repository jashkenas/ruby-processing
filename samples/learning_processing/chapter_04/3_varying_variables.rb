require 'ruby-processing'

class VaryingVariables < Processing::App

  def setup
    # Declare and initialize two integer instance variables.
    @circle_x = 0
    @circle_y = 100
    
    smooth
  end
  
  def draw
    background 255
    stroke 0
    fill 175
    
    # Use the variables to specify the location of the circle
    ellipse @circle_x, @circle_y, 50, 50
    
    # An assignment operation that increments the value of circle_x by 1.
    @circle_x += 1
  end
  
end

VaryingVariables.new :title => "Varying Variables", :width => 200, :height => 200