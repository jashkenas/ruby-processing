require 'ruby-processing'

class BouncingBallsWithIntersection < Processing::App
  def setup
    smooth
    # Create two balls.
    @ball_1, @ball_2 = Ball.new(64), Ball.new(32)
  end
  
  def draw
    background 255
    @ball_1.move
    @ball_2.move
    
    # New! Methods on objects that you define can take each other as arguments.
    # This is one way to have objects communicate.
    # In this case they're checking to see if they intersect.
    if @ball_1.intersect(@ball_2)
      @ball_1.highlight
      @ball_2.highlight
    end
    
    @ball_1.display
    @ball_2.display
  end
end


class Ball
  # We use attr_reader to make the @x, @y and @r instance variables readable by other objects.
  attr_reader :x, :y, :r
  
  def initialize(temp_r)
    @r = temp_r
    @x, @y = rand($app.width), rand($app.height)
    @x_speed, @y_speed = (rand * 10 - 5), (rand * 10 - 5)
    @color = $app.color(100, 50)
  end
  
  def move
    @x += @x_speed # Move the ball horizontally
    @y += @y_speed # Move the ball vertically
    
    @x_speed *= -1 unless (0..$app.width).include?(@x)
    @y_speed *= -1 unless (0..$app.height).include?(@y)
  end
  
  def highlight
    @color = $app.color(0, 150)
  end
  
  def display
    $app.stroke 0
    $app.fill @color
    $app.ellipse @x, @y, @r*2, @r*2
    # After the ball is displayed, the color is reset back to a dark gray.
    @color = $app.color(100, 50)
  end
  
  # A function that returns true or false based on whether or not two circles intersect.
  # If distance is less than the sum of the radii, the circles touch.
  # Objects that you define can be passed as arguments too!
  def intersect(other_ball)
    distance = $app.dist(@x, @y, other_ball.x, other_ball.y)
    distance < @r + other_ball.r
  end
end

BouncingBallsWithIntersection.new :title => "Bouncing Balls with Intersection", :width => 400, :height => 400