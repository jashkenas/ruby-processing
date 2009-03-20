# Example 17-3: Scrolling headlines
require 'ruby-processing'

class ScrollingHeadlines < Processing::App

  HEADLINES = "Processing downloads break downloading record.",
              "New study shows computer programming lowers cholesterol."

  def setup
    size 400, 200
    @f     = createFont "Arial" ,16, true
    @x     = width
    @index = 0
  end

  def draw
    background 255
    fill 0

    # Display headline at x location
    textFont @f, 16
    textAlign LEFT

    # A specific String from the array is displayed according to the value 
    # of the "index" variable.
    text HEADLINES[@index], @x, 180

    # Decrement x
    @x = @x - 3

    # If x is less than the negative width, then it is off the screen
    # textWidth() is used to calculate the width of the current String.
    w = textWidth(HEADLINES[@index])
    if (@x < -w) 
      @x = width
      # @index is incremented when the current String has left t
      # the screen in order to display a new String.
      @index = (@index + 1) % HEADLINES.length 
    end
  end

end

ScrollingHeadlines.new :title => "03 Scrolling Headlines"