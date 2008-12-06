require 'ruby-processing'

class WhileLoop < Processing::App

  def setup
    background 255 

    y = 80       # Vertical location of each line
    x = 50       # Initial horizontal location for first line
    spacing = 10 # How far apart is each line
    len = 20     # Length of each line

    # A variable to mark where the legs end.
    end_legs = 150 
    stroke 0 

    # Draw each leg inside a while loop.
    while  x <= end_legs 
      line  x, y, x, y + len 
      x = x + spacing
    end
  end
  
  def draw
  
  end
  
end

WhileLoop.new :title => "While Loop",  :width => 200,  :height => 200