require 'ruby-processing'

class LegsWithAForLoop < Processing::App

  def setup
    background 255
  end
  
  def reset_values
    @x = 50       # Horizontal location of first line
    @y = 80       # Vertical location of each line
    @spacing = 10 # How far apart is each line
    @len = 20     # Length of each line
  end
  
  def draw
    reset_values 
    
    # In ruby numbers also have methods.
    # The times method allows you to run a given block of code 
    # a certain number of times:
    
    10.times do
      line @x, @y, @x, @y + @len
      @x += @spacing
    end
    
    # There's also an alternative method called step,
    # You call it on the number you'd like to start with,
    # passing it the end number, and the size of the steps to take:
    # start_num.step(stop_num, step_size) { |value| do_something_with value ...
    
    50.step(150, @spacing) { |x| line x, @y, x, @y + @len }
    
    # The curly braces are an alternative form for writing do ... end.
    # So, I guess this isn't much of a demonstration of the for loop... 
  end
  
end

LegsWithAForLoop.new :title => "Legs With A For Loop",  :width => 200,  :height => 200