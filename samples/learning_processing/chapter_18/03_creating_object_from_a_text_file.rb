#
# Example 18-3: Creating objects from a text file
#
def setup
  size 200, 200
  smooth

  # Load text file as an array of Strings
  data = loadStrings("data-2.txt")

  # The size of the array of Bubble objects is determined by the 
  # total number of lines in the text file.
  @bubbles = []
  data.each do |datum|
    # Each line is split into an array of floating point numbers.
    values = float(split(datum, "," )) 
    # The values in the array are passed into the Bubble class constructor.
    @bubbles << Bubble.new(*values)
  end
end

def draw
  background 255
  # Display and move all bubbles
  @bubbles.each do |bubble|
    bubble.display
    bubble.drift
  end
end

#
# A Class to describe a "Bubble"
#
class Bubble
  # The constructor initializes color and size
  # Location is filled randomly
  def initialize(r, g, diameter)
    @x        = $app.random($app.width)
    @y        = $app.height
    @r        = r
    @g        = g
    @diameter = diameter
  end

  # Display the Bubble
  def display
    $app.stroke 0
    $app.fill @r, @g, 255, 150
    $app.ellipse @x, @y, @diameter, @diameter
  end

  # Move the bubble
  def drift
    @y += $app.random(-3, -0.1)
    @x += $app.random(-1, 1)
    if @y < -@diameter * 2
      @y = $app.height + @diameter * 2 
    end
  end
end
