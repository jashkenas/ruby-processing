require 'ruby-processing'

class HelloWorldImageSketch < Processing::App

  def setup
    puts $FILENAME
    puts $*
    puts __FILE__
    puts ARGF
    # the image file must be in the data directory
    @img = load_image "mysummervacation.jpg"
  end

  def draw
    background 0

    #The image function displays the image at a location-in this case the point (0,0).
    image @img, 0, 0
  end

end

HelloWorldImageSketch.new :title => "Hello World Image", :width => 320, :height => 240

