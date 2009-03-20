# Example 17-4: Text mirror 
require 'ruby-processing'

class TextMirror < Processing::App
  load_library "video"
  import "processing.video" 

  # Size of each cell in the grid, ratio of window size to video size
  VIDEOSCALE = 14

  # The source text used in the mosaic pattern. A longer String might produce more interesting results.
  CHARS      = "helloworld"

  def setup
    # size 640, 480
    # Set up columns and rows
    @cols  = width / VIDEOSCALE  # Number of columns and...
    @rows  = height / VIDEOSCALE # rows in our system
    @video = Capture.new(self, @cols, @rows, 15)

    # Load the font
    # Using a fixed-width font. In most fonts, individual characters have different widths. 
    # In a fixed-width font, all characters have the same width. 
    # This is useful here since we intend to display the letters one at a time spaced out evenly. 
    # See Section 17.7 for how to display text character by character with a nonfixed width font.
    @f = loadFont "Courier-Bold-20.vlw"
  end

  def draw
    background 0

    # Read image from the camera
    @video.read() if @video.available?
    @video.loadPixels()

    # Use a variable to count through chars in String
    charcount = 0
    # Begin loop for rows
    @rows.times do |j|
      # Begin loop for columns
      @cols.times do |i|

        # Where are we, pixel-wise?
        x = i * VIDEOSCALE
        y = j * VIDEOSCALE

        # Looking up the appropriate color in the pixel array
        c = @video.pixels[i + j * @video.width]

        # Displaying an individual character from the String instead of a rectangle
        textFont @f
        fill c

        # One character from the source text is displayed colored accordingly to the pixel location. 
        # A counter variableâ charcountâ is used to walk through the source String one character at a time.
        text CHARS[charcount].chr, x, y

        # Go on to the next character
        charcount = (charcount + 1) % CHARS.length
      end
    end  
  end

end

TextMirror.new :title => "04 Text Mirror", :width => 640, :height => 480