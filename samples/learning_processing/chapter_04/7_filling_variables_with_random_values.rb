require 'ruby-processing'

class FillingVariablesWithRandomValues < Processing::App

  def setup
    background 255
    smooth
  end
  
  def draw
    # Each time through draw, new random numbers 
    # are picked for a new ellipse.
    # We're using local variables here, not instance variables,
    # because we only need them in the draw method.
    r, g, b, a = random(255), random(255), random(255), random(255)
    diam = random(20)
    x, y = random(width), random(height)
    
    # Use the values to draw an ellipse
    no_stroke
    fill r, g, b, a
    ellipse x, y, diam, diam
  end
  
end

FillingVariablesWithRandomValues.new :title => "Filling Variables With Random Values", :width => 200, :height => 200