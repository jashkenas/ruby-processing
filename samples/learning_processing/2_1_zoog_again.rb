require 'ruby-processing'

class ZoogAgain < Processing::App

  def setup
    background 255 
    smooth  
    
    # Set ellipses and rects to CENTER mode
    ellipse_mode CENTER 
    rect_mode CENTER  

    # Draw Zoog's body
    stroke 0 
    fill 150 
    rect 100, 100, 20, 100 

    # Draw Zoog's head
    fill 255 
    ellipse 100, 70, 60, 60  

    # Draw Zoog's eyes
    fill 0  
    ellipse 81, 70, 16, 32  
    ellipse 119, 70, 16, 32 

    # Draw Zoog's legs
    stroke 0 
    line 90, 150, 80, 160 
    line 110, 150, 120, 160 
  end
  
  def draw
  
  end
  
end

ZoogAgain.new :title => "Zoog Again", :width => 200, :height => 200