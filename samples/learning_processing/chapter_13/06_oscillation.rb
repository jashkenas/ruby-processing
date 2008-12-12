require 'ruby-processing'

class OscillationSketch < Processing::App

  def setup
    @theta = 0
    smooth
  end

  def draw
    background 255
    # The output of the sin() function oscillates smoothly between 1 and 1. 
    # By adding 1 we get values between 0 and 2. 
    # By multiplying by 100, we get values between 0 and 200 which can be used as the ellipse's x location.
    x = (Math::sin(@theta) + 1) * width/2

    # with each cycle, increment theta
    @theta += 0.05
    fill 0
    stroke 0

    # draw the ellipse at the value produce by the sin
    line width/2, 0, x, height/2
    ellipse x, height/2, 32, 32
  end

end

OscillationSketch.new :title => "Oscillation", :width => 400, :height => 400
