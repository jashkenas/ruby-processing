require 'ruby-processing'

class ManyVariables < Processing::App

  def setup
    # We've got 8 variables now! They're all Floats.
    @circle_x, @circle_y = 0.0, 0.0
    @circle_w, @circle_h = 50.0, 100.0
    @circle_stroke = 255.0
    @circle_fill = 0.0
    @background_color = 255.0
    @change = 0.5
    
    smooth
  end
  
  def draw
    # Draw the background and the ellipse.
    # Variables are used for everything:
    # background, stroke, fill, location and size.
    background @background_color
    stroke @circle_stroke
    fill @circle_fill
    ellipse @circle_x, @circle_y, @circle_w, @circle_h
    
    # Change the values of all variables.
    # The variable change is used to update the others.
    @circle_x += @change
    @circle_y += @change
    @circle_w += @change
    @circle_h -= @change
    @circle_stroke -= @change
    @circle_fill += @change
  end
  
end

ManyVariables.new :title => "Many Variables", :width => 200, :height => 200