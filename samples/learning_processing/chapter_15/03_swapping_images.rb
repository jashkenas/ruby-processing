require 'ruby-processing'

class SwappingImagesSketch < Processing::App

  def setup
    @index = 0
    @count = 7
    # loading the images into the array
    @images = (0...@count).map { |i| load_image("animal#{i}.jpg") }
  end

  def draw
    # displaying one images
    image @images[@index], 0, 0 
  end

  def mouse_pressed
    # A new image is picked randomly when the mouse is clicked
    @index = rand(@images.size)
  end

end

SwappingImagesSketch.new :title => "Swapping Images", :width => 200, :height => 200

