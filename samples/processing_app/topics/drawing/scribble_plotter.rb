#
# Scribble Plotter  
# by Ira Greenberg. 
# 
# Using 2-dimensional arrays, record end points
# and replot scribbles between points. 
#

SCRIBBLE = 0
HATCHING = 1
attr_reader :xy

def setup
  size(640, 360)
  background(0)
  
  
  # Record points
  # X positions 
  x = [125, 475, 475, 125]
  # Y positions
  y = [100, 100, 260, 260]
  @xy = [x, y]
  
  # Call plotting function
  make_rect(xy)
end

def make_rect(pts)
  stroke(255)
  
  # Scribble variables, that get passed as arguments to the scribble function
  steps = 100
  scrib_val = 3.0
  (0 ... xy.length).each do |i| 
    # Plots vertices
    stroke_weight(5)
    point(pts[0][i], pts[1][i])
    
    # Call scribble function
    stroke_weight(0.5)
    if (i > 0) 
      scribble(pts[0][i], pts[1][i], pts[0][i-1], pts[1][i-1], steps, scrib_val, SCRIBBLE)
    end
    if (i == pts[0].length-1)
      # Show some hatching between last 2 points
      scribble(pts[0][i], pts[1][i], pts[0][0], pts[1][0], steps, scrib_val*2, HATCHING)
    end
  end
end


# Scribble function plots lines between end points, 
# determined by steps and scrib_val arguments.
# two styles are available: SCRIBBLE and HATCHING, which
# are interestingly only dependent on parentheses
# placement in the line function calls.


def scribble(x1, y1, x2, y2, steps, scrib_val, style)
  
  x_step = (x2-x1) / steps
  y_step = (y2-y1) / steps
  (0 ... steps).each do |i|
    if(style == SCRIBBLE)
      if (i < steps-1)
        line(x1, y1, x1 += x_step+rand(-scrib_val .. scrib_val), y1 += y_step + rand(-scrib_val .. scrib_val))      
      else
        # extra line needed to attach line back to point- not necessary in HATCHING style
        line(x1, y1, x2, y2)
      end
    elsif (style == HATCHING)
      line(x1, y1, (x1 += x_step)+rand(-scrib_val .. scrib_val), (y1 += y_step) + rand(-scrib_val .. scrib_val))
    end
  end
end

