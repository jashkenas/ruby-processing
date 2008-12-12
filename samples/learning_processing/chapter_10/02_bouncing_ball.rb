require 'ruby-processing'

class BouncingBallSketch < Processing::App
  def setup
    smooth
    
    # Create two balls.
    @ball_1, @ball_2 = Ball.new(64), Ball.new(32)
  end
  
  def draw
    background 255
    @ball_1.move
    @ball_2.move
    @ball_1.display
    @ball_2.display
  end
end


class Ball
  def initialize(temp_r)
    @r = temp_r
    @x, @y = rand($app.width), rand($app.height)
    @x_speed, @y_speed = (rand * 10 - 5), (rand * 10 - 5)
  end
  
  def move
    @x += @x_speed # Move the ball horizontally
    @y += @y_speed # Move the ball vertically
    
    # Check for the edges of the sketch
    @x_speed *= -1 unless (0..$app.width).include?(@x)
    @y_speed *= -1 unless (0..$app.height).include?(@y)
  end
  
  def display
    $app.stroke 0
    $app.fill 0, 50
    $app.ellipse @x, @y, @r*2, @r*2
  end
end

BouncingBallSketch.new :title => "Bouncing Ball", :width => 400, :height => 400