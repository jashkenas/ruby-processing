require 'ruby-processing'

# This example presents the fastest way to load a background image
# into Processing. To load an image as the background, it must be
# the same width and height as the program.

class BackgroundImage < Processing::App

  def setup
    frame_rate 30
    @a = 0
    
    # The background image must be the same size as the parameters
  	# into the size method. In this program, the size of "milan_rubbish.jpg"
  	# is 200 x 200 pixels.
    @background_image = load_image "milan_rubbish.jpg"
  end
  
  def draw
  	background @background_image
  	
  	@a = (@a + 1) % (width+32)
  	stroke 266, 204, 0
  	line 0, @a,   width, @a-26
  	line 0, @a-6, width, @a-32
  end
  
end

BackgroundImage.new :title => "Background Image", :width => 200, :height => 200