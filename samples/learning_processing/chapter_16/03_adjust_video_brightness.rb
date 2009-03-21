# Example 16-3: Adjust video brightness
require 'ruby-processing'

class AdjustVideoBrightness < Processing::App
  load_library "video"
  import "processing.video" 

  def setup
    size 240, 180, P3D

    # Initialize Capture object via Constructor
    # video is 320 x 240, @15 fps
    @video = Capture.new self, 240, 180, 15
    background 0
  end

  def draw
    # Check to see if a new frame is available
    # If so, read it.
    @video.read if @video.available?

    load_pixels
    @video.load_pixels
    pixs = @video.pixels
    mx, my = mouse_x, mouse_y
    max_dist  = 100
    vid_width, vid_height = @video.width, @video.height

    vid_width.times do |x|
      vid_height.times do |y|
        # Calculate the 1D location from a 2D grid
        loc = x + y * vid_width
        pix = pixs[loc]

        # Calculate an amount to change brightness based on proximity to the mouse
        d         = dist(x, y, mx, my)
        fudge     = (max_dist - d) / max_dist
        r, g, b   = red(pix) * fudge, green(pix) * fudge, blue(pix) * fudge

        # Make a new color and set pixel in the window
        pixels[loc] = color(r, g, b)
      end
    end
    update_pixels
  end

end

AdjustVideoBrightness.new :title => "Adjust Video Brightness"