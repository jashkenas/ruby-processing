require 'ruby-processing'

class InteractiveZoog < Processing::App

  def setup
    smooth
    # The frame rate (like a movie) is set to 30 frames per second
    frame_rate 30
  end
  
  def draw
    # draw a white background
    background 255
    
    # Set ellipses and rects to CENTER mode
    ellipse_mode CENTER 
    rect_mode CENTER  

    # Draw Zoog's body
    stroke 0 
    fill 150 
    rect mouse_x, mouse_y, 20, 100 

    # Draw Zoog's head
    stroke 0
    fill 255
    ellipse mouse_x, mouse_y - 30, 60, 60  

    # Draw Zoog's eyes
    # The eye color is determined by mouse location.
    fill mouse_x, 0, mouse_y
    ellipse mouse_x - 19, mouse_y - 30, 16, 32  
    ellipse mouse_x + 19, mouse_y - 30, 16, 32 

    # Draw Zoog's legs
    stroke 0
    # The legs are drawn according to where the mouse is now and where it used to be.
    line mouse_x - 10, mouse_y + 50, pmouse_x - 10, pmouse_y + 60 
    line mouse_x + 10, mouse_y + 50, pmouse_x + 10, pmouse_y + 60
  end
  
  def mouse_pressed
    # In Ruby, you can call 'puts' to print to the console.
    # 'print' also works (but doesn't make a new line).
    puts 'Take me to your leader!'
  end
  
end

InteractiveZoog.new :title => "Interactive Zoog?", :width => 200, :height => 200