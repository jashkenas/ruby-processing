require 'ruby-processing'

class EllipseWithVariables < Processing::App

  def setup
    # Initialize your variables (you don't have to declare 'em)
    @r, @g, @b, @a = 100, 150, 200, 200
    @x, @y = 100, 100
    @diam = 20
    
    background 255
    smooth
  end
  
  def draw
    # Use the variables to draw an ellipse
    stroke 0
    fill @r, @g, @b, @a # Remember, the fourth argument for a color means opacity.
    ellipse @x, @y, @diam, @diam
  end
  
end

EllipseWithVariables.new :title => "Ellipse With Variables", :width => 200, :height => 200