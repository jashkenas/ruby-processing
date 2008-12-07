require 'ruby-processing'

class FunctionReturnsDistance < Processing::App

  def setup
  
  end
  
  def draw
    background 0
    stroke 0
    
    # Set up width/2-1 and height/2-1 variables, for convenience.
    w1, h1 = width/2-1, height/2-1
    
    # Top left square
    # Our distance function is used to calculate a brightness value
    # for each quadrant. We could use the built-in function dist 
    # instead, but we are learning how to write our own functions.
    fill distance(0, 0, mouse_x ,mouse_y)
    rect 0, 0, w1, h1
    
    # Top right square
    fill distance(width, 0, mouse_x, mouse_y)
    rect width/2, 0, w1, h1
    
    # Bottom left square
    fill distance(0, height, mouse_x, mouse_y)
    rect 0, height/2, w1, h1
    
    # Bottom right square
    fill distance(width, height, mouse_x, mouse_y)
    rect width/2, height/2, w1, h1
  
  end
  
  # Defining the distance method.
  # In Ruby we don't have to write "return", because Ruby implicitly
  # returns the last thing that was evaluated from any method.
  def distance x1, y1, x2, y2
    dx = x1 - x2
    dy = y1 - y2
    sqrt(dx*dx + dy*dy)
  end
  
end

FunctionReturnsDistance.new :title => "Function Returns Distance", :width => 200, :height => 200