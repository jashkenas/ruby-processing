require 'ruby-processing'

class InfiniteLoop < Processing::App

  def setup
  
  end
  
  def draw
    
    x = 0
    while x < 10
      puts x
      # Decrementing x results in an infinite loop here because the value of x will never be 10 or greater. 
      # Be careful!
      x = x - 1
    end

    # This example does not include the break function.
    # To stop the runaway loop, close the window or use control-c in the terminal.
  end
  
end

InfiniteLoop.new :title => "Infinite Loop (Don't do this)", :width => 200, :height => 200