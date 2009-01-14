require 'ruby-processing'

class CaptureVideoSketch < Processing::App

  # Step 1. Import the video library
  load_java_library "video"
  # We need the video classes to be included here.
  include_package "processing.video" 

  def setup
    # Step 2. Declare a Capture object
    @video = Capture.new(self, width, height, 30)
  end

  def draw
    # Step 3 and 4: Read from the camera if it's available.
    @video.read if @video.available

    # Step 5. Display the video image.
    image @video, 0, 0
  end

end

CaptureVideoSketch.new :title => "Capture Video", :width => 320, :height => 240
