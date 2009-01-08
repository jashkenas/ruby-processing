require 'ruby-processing'

class SwappingImagesSketch < Processing::App

  def setup
    @image_index = 0
    @image_count = 7
    # loading the images into the array
    @images = (0...@image_count).collect { |t| load_image("animal#{t}.jpg") }
    frame_rate 5
  end

  def draw
    # displaying one images
    image @images[@image_index], 0, 0 
    @image_index = (@image_index + 1) % @images.size
  end

end

SwappingImagesSketch.new :title => "Swapping Images", :width => 200, :height => 200

