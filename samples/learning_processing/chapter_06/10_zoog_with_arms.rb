require 'ruby-processing'

class ZoogwithArms < Processing::App

  def setup
    @x, @y = 100,  100
    @w, @h = 60,  60
    @eye_size = 16
    @speed = 1
    smooth
    
    # Set ellipses and rects to CENTER mode
    # We can do this in setup because we only need to do it once
    ellipseMode CENTER 
    rectMode CENTER
  end
  
  def draw
    # Change the x location of Zoog by speed
    @x += @speed

    # If we've reached an edge, reverse speed  i.e. multiply it by -1 
    # Note if speed is a + number, square moves to the right, - to the left 
    @speed *= -1 if @x > @width || @x < 0

    background 255  # Draw a white background
    stroke 0        # Set the stroke color to black

    # Arms are incorporated into Zoog's design with a times loop.
    6.times do |i|
      y = i * 10 + @y + 5
      line @x-@w/3, y, @x+@w/3, y
    end

    # Draw Zoog's body
    fill 175 
    rect @x, @y, @w/6, @h*2 

    # Draw Zoog's head
    fill 255 
    ellipse @x, @y-@h/2, @w, @h 

    # Draw Zoog's eyes
    fill 0 
    ellipse @x-@w/3+1, @y-@h/2, @eye_size, @eye_size*2 
    ellipse @x+@w/3-1, @y-@h/2, @eye_size, @eye_size*2 

    # Draw Zoog's legs
    line @x-@w/12, @y+@h, @x-@w/4, @y+@h+10 
    line @x+@w/12, @y+@h, @x+@w/4, @y+@h+10
    
  end
  
end

ZoogwithArms.new :title => "Zoog with Arms",  :width => 200,  :height => 200