require 'ruby-processing'

class ManyLinesWithVariables < Processing::App

  def setup
    background 255
    
    # Legs
    stroke 0 
    y = 80       # Vertical location of each line
    x = 50       # Initial horizontal location for first line
    spacing = 10 # How far apart is each line
    len = 20     # Length of each line

    # Draw the first leg.
    line x, y, x, y + len  
    # Add spacing so the next leg appears 10 pixels to the right.
    x = x + spacing 

    # You could continue this process for each leg, like in the original
    # example, but it's pretty silly to repeat any chunk of code so many times:
    
    line x, y, x, y + len  
    x = x + spacing
    line x, y, x, y + len 
    x = x + spacing
    line x, y, x, y + len 
    x = x + spacing
    line x, y, x, y + len 
    x = x + spacing
    line x, y, x, y + len 
    x = x + spacing
    line x, y, x, y + len 
    x = x + spacing
    line x, y, x, y + len 
    x = x + spacing
    line x, y, x, y + len 
    x = x + spacing
    line x, y, x, y + len 
    x = x + spacing
    line x, y, x, y + len
    
    # A nicer way is to repeat that chunk of code with a block,
    # you can see how in example 06.
  end
  
  def draw
  
  end
  
end

ManyLinesWithVariables.new :title => "Many Lines With Variables",  :width => 200,  :height => 200