#
# Example 17-6: Text breaking up 
#
def setup
  size 260, 200
  @message = "click mouse to shake it up"
  textFont createFont("Arial", 20, true)

  # Create the array 
  @letters = []

  # Initialize Letters at the correct x location
  x = 16
  @message.each_byte do |letter|
    # Letter objects are initialized with their location within 
    # the String as well as what character they should display.
    @letters << Letter.new(x, 100, letter.chr)
    x += textWidth(letter)
  end
end

def draw
  background 255
  @letters.each do |letter|

    # Display all letters
    letter.display

    # If the mouse is pressed the letters shake
    # If not, they return to their original location
    if mouse_pressed?
      letter.shake
    else
      letter.home
    end
  end
end

#
# A class to describe a single Letter
#
class Letter
  # The letter that this instance represent
  attr_reader :letter

  # The object knows its original " home " location
  attr_reader :homex, :homey

  # As well as its current location
  attr_reader :x, :y

  def initialize(x, y, letter)
    @homex  = @x = x
    @homey  = @y = y
    @letter = letter
  end

  # Display the letter
  def display
    $app.fill 0
    $app.textAlign Processing::App::LEFT
    $app.text @letter, @x, @y
  end

  # Move the letter randomly
  def shake
    @x += $app.random(-2, 2)
    @y += $app.random(-2, 2)
  end

  # At any point, the current location can be set back to 
  # the home location by calling the home() function.
  def home
    @x = @homex
    @y = @homey
  end
end
