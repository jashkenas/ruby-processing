require 'ruby-processing'

class BouncingBallWithFunctions < Processing::App

  def setup
    # Declare variables
    @x = 1
    @speed = 1
    smooth
  end
  
  def draw
    background 255
    # Instead of writing out all the code about the ball 
    # in draw, we simply call three functions. How do 
    # we know the names of these functions? We made them up!
    move
    bounce
    display
  end
  
  # Where should functions be placed?
  # You can define your functions anywhere in the code outside of setup and draw.
  # However, the convention is to place your function definitions below draw.

  # A function to move the ball
  def move
    # Change the x location by speed
    @x += @speed
  end

  # A function to bounce the ball
  def bounce
    # If we’ve reached an edge, reverse speed
    # (0..width) is a Ruby range, representing the numbers from 0 to width (aka 200).
    # You can ask a range if it includes another number or not.
    @speed *= -1 unless (0..width).include? @x
  end

  # A function to display the ball
  def display
    stroke 0
    fill 175
    ellipse @x, 100, 32, 32
  end
  
end

BouncingBallWithFunctions.new :title => "Bouncing Ball With Functions", :width => 200, :height => 200