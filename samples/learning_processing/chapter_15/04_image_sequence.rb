require 'ruby-processing'

class ImageSequence < Processing::App

  def setup
    @index = 0
    @count = 7
    # loading the images into the array
    @images = (0...@count).map { |i| load_image("animal#{i}.jpg") }
    frame_rate 5
  end

  def draw
    # displaying one images
    image @images[@index], 0, 0 
    @index = (@index + 1) % @images.size
  end

end

ImageSequence.new :title => "Image Sequence", :width => 200, :height => 200

