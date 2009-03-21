HEADLINES = "Processing downloads break downloading record.",
            "New study shows computer programming lowers cholesterol."

def setup
  size 400, 200
  @f     = create_font "Arial" ,16, true
  @x     = width
  @index = 0
end

def draw
  background 255
  fill 0

  # Display headline at x location
  text_font @f, 16
  text_align LEFT

  # A specific string from the array is displayed according to the value 
  # of the "index" variable.
  text HEADLINES[@index], @x, 180

  # Decrement x
  @x = @x - 3

  # If x is less than the negative width, then it is off the screen
  # text_width is used to calculate the width of the current string.
  w = text_width(HEADLINES[@index])
  if (@x < -w) 
    @x = width
    # @index is incremented when the current string has left
    # the screen in order to display a new string.
    @index = (@index + 1) % HEADLINES.length 
  end
end