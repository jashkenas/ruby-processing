require 'ruby-processing'

class AnotherInfiniteLoop < Processing::App

  def setup
    @y = 80        # Vertical location of each line
    @x = 0         # Horizontal location of first line
    @spacing = 10  # How far apart is each line
    @len = 20      # Length of each line
    @end_legs = 150 # Where should the lines stop?
  end
  
  def draw
    # The spacing variable, which sets the distance in between each line,
    # is assigned a value equal to mouseX divided by two.
    # THIS LINE IS COMMENTED OUT SO THAT THE SKETCH DOES NOT CRASH
    # IF YOU PUT IT BACK IN THIS SKETCH WILL CRASH!
    # @spacing = mouse_x / 2

    # Exit Condition: when x is greater than endlegs.
    while @x <= @end_legs
      line @x, @y, @x, @y + @len
      # Incrementation of x. 
      # x always increases by the value of spacing.
      #  What is the range of possible values for spacing?
      @x = @x + @spacing
    end
  
  end
  
end

AnotherInfiniteLoop.new :title => "Another Infinite Loop", :width => 200, :height => 200