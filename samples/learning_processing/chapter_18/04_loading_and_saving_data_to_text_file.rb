#
# Example 18-4: Loading and saving data to text file
#
def setup
  size 200, 200
  smooth

  # Load text file as an array of Strings
  data = load_strings("data-2.txt")

  # The size of the array of Bubble objects is determined by the 
  # total number of lines in the text file.
  @bubbles = []
  data.each do |datum|
    # Each line is split into an array of floating point numbers.
    values = float(split(datum, ","))
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

    # Change bubbles if mouse rolls over
    bubble.change if bubble.rollover(mouse_x, mouse_y)
  end
end

# Save new Bubble data when mouse is pressed
def mouse_pressed
  save_data
end

def save_data
  # For each Bubble make one String to be saved
  data = []

  @bubbles.each do |bubble|
    # Concatenate bubble variables
    data << "#{bubble.r}, #{bubble.g}, #{bubble.diameter}"
  end

  # Save to File
  # The same file is overwritten by adding the data folder path to saveStrings().
  save_strings("data/data-2.txt", data)
end

#
# A Class to describe a "Bubble"
#
class Bubble
  attr_reader :r, :g, :diameter

  # The constructor initializes color and size
  # Location is filled randomly
  def initialize(r, g, diameter)
    @x        = $app.random($app.width)
    @y        = $app.height
    @r        = r
    @g        = g
    @diameter = diameter
  end

  # True or False if point is inside circle
  def rollover(mx, my)
    $app.dist(mx, my, @x, @y) < diameter / 2
  end

  # Change Bubble variables
  def change
    @r        = $app.constrain(@r + $app.random(-10, 10), 0, 255)
    @g        = $app.constrain(@g + $app.random(-10, 10), 0, 255)
    @diameter = $app.constrain(@diameter + $app.random(-2, 4), 4, 72)
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
