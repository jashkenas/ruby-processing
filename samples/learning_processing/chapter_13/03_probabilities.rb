require 'ruby-processing'

class ProbabilitiesSketch < Processing::App
  def setup
    $app.background 255
    $app.smooth
    $app.noStroke
  end

  def draw

    # Probabilities for 3 different cases
    #   These need to add up to 100%!
    red_prob = 0.60   # 60% chance of red color
    green_prob = 0.10 # 10% chance of green color
    blue_prob = 0.30  # 30% chance of blue color

    # Pick a random number between 0 and 1
    num = rand  

    # If random number is less than .6
    if num < red_prob  
      $app.fill 255,53,2,150 
      # If random number is between .6 and .7
    elsif (num < green_prob + red_prob) 
      $app.fill 156,255,28,150 
      # All other cases (i.e. between .7 and 1.0)
    else 
      $app.fill 10,52,178,150 
    end

    # Draw ellipse
    $app.ellipse random($app.width), random($app.height), 64, 64
  end

end


ProbabilitiesSketch.new :title => "Probabilities", :width => 400, :height => 400
