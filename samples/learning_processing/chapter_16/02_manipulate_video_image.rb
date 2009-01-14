require 'ruby-processing'

class ManipulateVideoImageSketch < Processing::App

  load_java_library "video"
  include_package "processing.video" 

  def setup
    @video = Capture.new(self, width, height, 30)
  end

  def draw
    @video.read if @video.available

    # Tinting using mouse location
    tint mouse_x, mouse_y, 255

    # A video image can also be tinted and resized just as with a PImage.
    image @video, 0, 0, mouse_x, mouse_y
  end

end

ManipulateVideoImageSketch.new :title => "Manipulate Video Image", :width => 320, :height => 240
