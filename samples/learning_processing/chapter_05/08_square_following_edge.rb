require 'ruby-processing'

class SquareFollowingEdge < Processing::App

  def setup
    @x, @y = 0, 0 # x and y locations of the square
    @speed = 5    # speed of square
    
    # A variable to keep track of the square's "state."  
    # Depending on the value of its state, it will either move right,  down,  left,  or up.
    @state = 0
  end
  
  def draw
    background 255
    
    # Display the square.
    stroke 0
    fill 175
    rect @x, @y, 9, 9
    
    # The following section uses a "case" statement. Cases let you
    # set up different blocks of code for specific values of variables,
    # as an alternative to a long if, elsif, else, kind of structure.
    
    # If the state is 0,  move to the right.
    case @state
    when 0
      @x = @x + @speed
      # If,  while the state is 0,  it reaches the right side of the window,  change the state to 1
      # Repeat this same logic for all states!?
      if @x > width-10
        @x = width-10
        @state = 1
      end
    when 1
      @y = @y + @speed
      if @y > height-10
        @y = height-10
        @state = 2
      end
    when 2
      @x = @x - @speed
      if @x < 0
        @x = 0
        @state = 3
      end
    when 3
      @y = @y - @speed;
      if @y < 0
        @y = 0
        @state = 0
      end
    end
  
  end
end

SquareFollowingEdge.new :title => "Square Following Edge",  :width => 200,  :height => 200