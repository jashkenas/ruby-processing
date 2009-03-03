require 'ruby-processing'

# The createImage() function provides a fresh buffer of pixels to play with.
# This example creates an image gradient.

class CreateImage < Processing::App

  def setup
    @image = create_image 120, 120, ARGB
    @image.pixels.length.times do |i|
    	@image.pixels[i] = color 0, 90, 102, (i % @image.width * 2) # red, green, blue, alpha
    end
  end
  
  def draw
  	background 204
  	image @image, 33, 33
  	image @image, mouse_x-60, mouse_y-60
  end
  
end

CreateImage.new :title => "Create Image", :width => 200, :height => 200