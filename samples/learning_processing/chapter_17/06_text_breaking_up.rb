require 'ruby-processing'

class TextBreakingUp < Processing::App

  def setup
    size 260, 200
    fill 0
    text_align LEFT
    text_font create_font("Arial", 20, true)
    @message = "click mouse to shake it up"

    # Create the array 
    @letters = []

    # Initialize Letters at the correct x location
    x = 16
    @message.each do |letter|
      # Letter objects are initialized with their location within 
      # the String as well as what character they should display.
      @letters << Letter.new(x, 100, letter)
      x += text_width(letter)
    end
  end

  def draw
    background 255
    @letters.each do |letter|
      letter.display
      # If the mouse is pressed the letters shake
      # If not, they return to their original location
      mouse_pressed? ? letter.shake : letter.home
    end
  end

end

# A class to describe a single Letter
class Letter
  # The letter that this instance represents
  attr_reader :letter

  # The object knows its original "home" location...
  attr_reader :homex, :homey

  # As well as its current location
  attr_reader :x, :y

  def initialize(x, y, letter)
    @home_x = @x = x
    @home_y = @y = y
    @letter = letter
  end

  # Display the letter
  def display
    $app.text @letter, @x, @y
  end

  # Move the letter randomly
  def shake
    @x += rand * 4 - 2
    @y += rand * 4 - 2
  end

  # At any point, the current location can be set back to 
  # the home location by calling the home() method.
  def home
    @x = @home_x
    @y = @home_y
  end
end

TextBreakingUp.new :title => "Text Breaking Up"