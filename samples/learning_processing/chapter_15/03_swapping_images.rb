require 'ruby-processing'

class SwappingImagesSketch < Processing::App

  def setup
    @image_index = 0
    @image_count = 7
    # loading the images into the array
    @images = (0...@image_count).collect { |t| load_image("animal#{t}.jpg") }
  end

  def draw
    # displaying one images
    image @images[@image_index], 0, 0 
  end

  def mouse_pressed
    # A new image is picked randomly when the mouse is clicked
    @image_index = rand(@images.size)
  end

end

SwappingImagesSketch.new :title => "Swapping Images", :width => 200, :height => 200

