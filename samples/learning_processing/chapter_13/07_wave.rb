require 'ruby-processing'

class WaveSketch < Processing::App

  def setup
    @theta = 0
    smooth
  end

  def draw
    background 255
    # Increment theta (try different values for " angular velocity " here)
    @theta += 0.02
    no_stroke
    fill 0
    x = @theta

    # times is used to draw all the points along a sine wave (scaled to the pixel dimension of the window).
    20.times do |i|
      # Calculate y value based off of sine function
      y = sin(x) * height/2
      # Draw an ellipse
      ellipse i*10, y+height/2, 16, 16
      # Move along x-axis
      x += 0.2
    end
  end

end

WaveSketch.new :title => "Oscillation", :width => 200, :height => 200
