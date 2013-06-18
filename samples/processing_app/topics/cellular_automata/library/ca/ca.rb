SCL = 1 # cell length

class CA
  include Processing::Proxy
  attr_reader :rules, :generation, :cells, :height, :width
  
  def initialize(rules = [])
    @width = $app.width
    @height = $app.height
    if rules.length > 0
      @rules = rules
    else
      randomize
    end
    @cells = Array.new(width / SCL, 0)
    restart
  end
  
  # Set the rules of the CA
  def set_rules(r)
    @rules = r
  end
  
  # Return a random ruleset
  def randomize
    @rules = Array.new(8) {(rand(100) > 50)? 1 : 0}
  end
  
  # Reset to generation 0
  def restart
    @cells = Array.new(width / SCL, 0)
    cells[cells.length/2] = 1    # We arbitrarily start with just the middle cell having a state of "1"
    @generation = 0
  end
  
  # The process of creating the new generation
  def generate
    # First we create an empty array for the new values
    nextgen = Array.new(cells.length, 0)
    # For every spot, determine new state by examing current state, and neighbour states
    # Ignore edges that only have one neighbour
    (1 ... cells.length - 1).each do |i|
      left = cells[i-1]   # Left neighbour state
      me = cells[i]       # Current state
      right = cells[i+1]  # Right neighbour state
      nextgen[i] = execute_rules(left, me, right) # Compute next generation state based on ruleset
    end
    # Copy the array into current value
    (1 .. cells.length - 1).each do |i|
      cells[i] = nextgen[i]
    end
    @generation += 1
  end
  
  # This is the easy part, just draw the cells, fill 255 for '1', fill 0 for '0'
  def render
    (0 ... cells.length).each do |i|
      if (cells[i] == 1)
        fill(255)
      else 
        fill(0)
      end
      no_stroke
      rect(i*SCL, generation*SCL, SCL, SCL)
    end
  end
  
  
  def execute_rules(a, b, c)
    val = 0
    case a + b + c
    when 3
      val = 0
    when 0
      val = 7
    when 1
      val = (a == 1)? 3 : (b == 1)? 5 : 6
    when 2
      val = (c == 0)? 1 : (a == 0)? 4 : 2
    else
      return val   # default is zero
    end
    return rules[val] # otherwise val is index
  end
  
  
  # The CA is done if it reaches the bottom of the screen
  def finished?
    return (generation > (height/SCL))
  end
end
