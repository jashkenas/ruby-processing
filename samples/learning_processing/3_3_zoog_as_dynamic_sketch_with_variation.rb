require 'ruby-processing'

class ZoogAsDynamicSketchWithVariation < Processing::App

  def setup
    smooth
  end
  
  def draw
    background 255 # Draw a white background
    
    # Set ellipses and rects to CENTER mode
    ellipse_mode CENTER 
    rect_mode CENTER  

    # Draw Zoog's body
    stroke 0 
    fill 150 
    # Zoog's body is drawn at the location (mouse_x, mouse_y)
    rect mouse_x, mouse_y, 20, 100 

    # Draw Zoog's head
    stroke 0
    fill 255
    # Zoog's head is drawn above the body at the location (mouse_x, mouse_y - 30)
    ellipse mouse_x, mouse_y - 30, 60, 60  

    # Draw Zoog's eyes
    fill 0  
    ellipse 81, 70, 16, 32  
    ellipse 119, 70, 16, 32 

    # Draw Zoog's legs
    stroke 0 
    line 90, 150, 80, 160 
    line 110, 150, 120, 160
  end
  
end

ZoogAsDynamicSketchWithVariation.new :title => "Zoog As Dynamic Sketch With Variation", :width => 200, :height => 200