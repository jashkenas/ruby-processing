require 'ruby-processing'

class ZoogWithFunctions < Processing::App

  def setup
    @x, @y = 100, 100
    @w, @h = 60, 60
    @eye_size = 16
    @speed = 1
    ellipse_mode CENTER 
    rect_mode CENTER
    stroke 0
    smooth
  end
  
  def draw
    background 255 # Draw a black background
    
    # mouse_x position determines speed factor for moveZoog function
    factor = constrain mouse_x/10, 0, 5
    
    # The code for changing the variables associated with Zoog and 
    # displaying Zoog is moved outside of draw and into functions
    # called here. The functions are given arguments, such as 
    # "Jiggle Zoog by the following factor" and "draw Zoog with 
    # the following eye color".
    jiggle_zoog factor
    
    # pass in a color to the draw_zoog function for eye color
    d = dist(@x, @y, mouse_x, mouse_y)
    c = color(d)
    draw_zoog c
  end
  
  def jiggle_zoog speed
    # Change the x and y location of Zoog randomly
    @x = @x + random(-1, 1) * speed
    @y = @y + random(-1, 1) * speed
    # Constrain Zoog to window
    @x = constrain @x, 0, width
    @y = constrain @y, 0, height
  end
  
  def draw_zoog eye_color
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
    fill eye_color
    ellipse @x-@w/3+1, @y-@h/2, @eye_size, @eye_size*2 
    ellipse @x+@w/3-1, @y-@h/2, @eye_size, @eye_size*2 

    # Draw Zoog's legs
    line @x-@w/12, @y+@h, @x-@w/4, @y+@h+10 
    line @x+@w/12, @y+@h, @x+@w/4, @y+@h+10
  end
  
end

ZoogWithFunctions.new :title => "Zoog With Functions", :width => 200, :height => 200