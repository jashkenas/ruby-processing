require 'ruby-processing'

class BouncingBall < Processing::App

  def setup
    @x = 0
    @speed = 1
    smooth
  end
  
  def draw
    background 255
    
    # Add the current speed to the x location.
    # += means x = x + speed
    @x += @speed
    
    # Remember, || means "or" and && means "and". 
    # speed *= -1 means (speed = speed * -1)
    # this one line if statement works the way it looks
    # (do this thing) if (this thing is true)
    @speed *= -1 if @x > width || @x < 0
    
    # Draw a circle at @x location.
    stroke 0
    fill 175
    ellipse @x, 100, 32, 32
  
  end
  
end

BouncingBall.new :title => "Bouncing Ball", :width => 200, :height => 200