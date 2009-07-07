require File.dirname(__FILE__) + '/../lib/ruby-processing.rb'

class MySketch < Processing::App
  attr_accessor :extended_option

  # Let's define a setup method, for code that gets
  # run one time when the app is started.
  def setup
    background 0
    no_stroke
    smooth
    frame_rate 10

    @font = create_font('Helvetica', 16)
    text_font @font
    @rotation = 0
  end

  # And the draw method which will be called repeatedly.
  # Delete this if you don't need animation.
  def draw
    fill 0
    rect 0, 0, width, height

    translate width/2, height/2
    rotate @rotation

    fill 255
    text @message, 20, 20
#    ellipse 0, -60, 20, 20

    @rotation += 0.1
  end
end

S = MySketch.new :title => 'extended_initialization', :width => 500, :height => 500, :message => 'Any text goes here...'