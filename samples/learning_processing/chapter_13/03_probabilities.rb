require 'ruby-processing'

class ProbabilitiesSketch < Processing::App
  def setup
    background 255
    smooth
    no_stroke
  end

  def draw
    # Probabilities for 3 different cases
    # These need to add up to 100%!
    red_prob = 0.60   # 60% chance of red color
    green_prob = 0.70 # 10% chance of green color
    blue_prob = 1.00  # 30% chance of blue color

    # Pick a random number between 0 and 1
    num = rand  

    case num
      when (0.0..red_prob):         fill(255, 53,  2,   150)
      when (red_prob..green_prob):  fill(156, 255, 28,  150)
      when (green_prob..blue_prob): fill(10,  52,  178, 150)
    end

    # Draw ellipse
    ellipse rand(width), rand(height), 64, 64
  end

end


ProbabilitiesSketch.new :title => "Probabilities", :width => 400, :height => 400
