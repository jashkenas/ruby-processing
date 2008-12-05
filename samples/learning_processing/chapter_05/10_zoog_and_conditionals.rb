require 'ruby-processing'

class ZoogAndConditionals < Processing::App

  def setup
    @x, @y, @w, @h = 100.0, 100.0, 60.0, 60.0
    @eye_size = 16.0
    
    # Zoog has variables for speed in the horizontal and vertical direction.
    @x_speed, @y_speed = 3.0, 1.0
    smooth  
  end
  
  def draw
    # Change the location of Zoog by speed
    @x += @x_speed
    @y += @y_speed
    
    # An IF statement with a logical OR determines if Zoog has reached either 
    # the right or left edge of the screen.  
    # When this is true, we multiply speed by -1, reversing Zoog's direction!
    # Identical logic is applied to the y direction as well.
    @x_speed *= -1 if @x > width || @x < 0
    @y_speed *= -1 if @y > height || @y < 0
    
    background 255
    ellipse_mode CENTER
    rect_mode CENTER
    
    # Draw Zoog's body
    stroke 0
    fill 150
    rect @x, @y, @w/6, @h*2
    
    # Draw Zoog's head
    # added () to make order of operations a bit more clear
    fill 255
    ellipse @x, @y-@h/2, @w, @h 
    
    # Draw Zoog's eyes
    fill 0 
    ellipse @x-@w/3+1, @y-@h/2, @eye_size, @eye_size*2 
    ellipse @x+@w/3-1, @y-@h/2, @eye_size, @eye_size*2
    
    # Draw Zoog's legs
    stroke 0
    line @x-@w/12, @y+@h, @x-@w/4, @y+@h+10
    line @x+@w/12, @y+@h, @x+@w/4, @y+@h+10
  end
  
end

ZoogAndConditionals.new :title => "Zoog And Conditionals",  :width => 200,  :height => 200