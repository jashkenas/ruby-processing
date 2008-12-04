require 'ruby-processing'

class ZoogAsDynamicSketch < Processing::App

  # Setup runs first one time.
  # In Ruby-Processing, you never need to call size(),
  # just set the width and height when you instantiate the sketch,
  # at the bottom.
  def setup
  
  end
  
  # Draw loops continuously until you close the sketch window.
  def draw
    # Draw a white background
    background 255 
    
    # Set CENTER mode
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
  
end

ZoogAsDynamicSketch.new :title => "Zoog As Dynamic Sketch", :width => 200, :height => 200