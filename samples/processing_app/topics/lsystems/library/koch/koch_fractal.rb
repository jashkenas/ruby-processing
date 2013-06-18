# Koch Curve
# A class to manage the list of line segments in the snowflake pattern


class KochFractal
  include Processing::Proxy
  attr_reader :start, :endk, :lines, :count
  
  def initialize width, height
    @start = PVector.new(0, height - 20)
    @endk = PVector.new(width, height - 20)  
    restart
  end

  def next_level  
    # For every line that is in the arraylist
    # create 4 more lines in a new arraylist
    @lines = iterate(lines)
    @count += 1
  end

  def restart 
    @count = 0      # Reset count
    @lines = []     # Empty the array list
    lines << KochLine.new(start, endk)  # Add the initial line (from one end PVector to the other)
  end
  
  def get_count
    return count
  end
  
  # This is easy, just draw all the lines
  def render
    lines.each do |line|
      line.display
    end
  end

  # This is where the **MAGIC** happens
  # Step 1: Create an empty array
  # Step 2: For every line currently in the array
  #   - calculate 4 line segments based on Koch algorithm
  #   - add all 4 line segments into the new array
  # Step 3: Return the new array and it becomes the list of line segments for the structure
  
  # As we do this over and over again, each line gets broken into 4 lines, which gets broken into 4 lines, and so on. . . 
  def iterate(before)
    now = []    # Create empty list
    before.each do |line|
      # Calculate 5 koch PVectors (done for us by the line object)
      a = line.start                 
      b = line.kochleft
      c = line.kochmiddle
      d = line.kochright
      e = line.endk
      # Make line segments between all the PVectors and add them
      # Note how we can chain '<<' in ruby, could all be in one line.
      now << KochLine.new(a,b) << KochLine.new(b,c)
      now << KochLine.new(c,d) << KochLine.new(d,e)
    end
    return now
  end
end

# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# Koch Curve
# A class to describe one line segment in the fractal
# Includes methods to calculate mid PVectors along the line according to the Koch algorithm

class KochLine
  include Processing::Proxy
  # Two PVectors,
  # a is the "left" PVector and 
  # b is the "right PVector
  attr_reader :start, :endk

  def initialize(start, endk)
    @start = start.get
    @endk = endk.get
  end

  def display
    stroke(255)
    line(start.x, start.y, endk.x, endk.y)
  end

  # This is easy, just 1/3 of the way
  def kochleft
    v = PVector.sub(endk, start)
    v.div(3)
    v.add(start)
    return v
  end    

  # More complicated, have to use a little trig to figure out where this PVector is!
  def kochmiddle
    v = PVector.sub(endk, start)
    v.div(3)    
    p = start.get
    p.add(v)    
    v.rotate(-radians(60))
    p.add(v)    
    return p
  end    

  # Easy, just 2/3 of the way
  def kochright
    v = PVector.sub(start, endk)
    v.div(3)
    v.add(endk)
    return v
  end
end

