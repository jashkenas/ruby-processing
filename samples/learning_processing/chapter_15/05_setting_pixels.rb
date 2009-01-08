require 'ruby-processing'

class SettingPixelsSketch < Processing::App

  def setup
    # load the pixels array
    load_pixels
    background 0
    # loop through the pixels and set each one to a random greyscale color
    pixels.size.times { |i| pixels[i] = color(rand 255) }
    # update the pixels on screen
    update_pixels
  end


end

SettingPixelsSketch.new :title => "Setting Pixels", :width => 200, :height => 200

