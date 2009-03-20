# Example 16-3: Adjust video brightness
require 'ruby-processing'

class AdjustVideoBrightness < Processing::App
  load_library "video"
  import "processing.video" 

  def setup
    size 320, 240

    # Initialize Capture object via Constructor
    # video is 320 x 240, @15 fps
    @video = Capture.new self, 320, 240, 15
    background 0
  end

  def draw
    # Check to see if a new frame is available
    # If so, read it.
    @video.read if @video.available?

    loadPixels
    @video.loadPixels

    @video.width.times do |x|
      @video.height.times do |y|
        # Calculate the 1D location from a 2D grid
        loc = x + y * @video.width

        # Get the R,G,B values from image
        r = red(@video.pixels[loc])
        g = green(@video.pixels[loc])
        b = blue(@video.pixels[loc])

        # Calculate an amount to change brightness based on proximity to the mouse
        maxdist          = 100
        d                = dist(x, y, mouseX, mouseY)
        adjustbrightness = (maxdist - d) / maxdist
        r *= adjustbrightness
        g *= adjustbrightness
        b *= adjustbrightness

        # Constrain RGB to make sure they are within 0-255 color range
        r = constrain(r, 0, 255)
        g = constrain(g, 0, 255)
        b = constrain(b, 0, 255)

        # Make a new color and set pixel in the window
        pixels[loc] = color(r, g, b)
      end
    end
    updatePixels
  end

end

AdjustVideoBrightness.new :title => "03 Adjust Video Brightness"