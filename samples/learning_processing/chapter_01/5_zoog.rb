require 'ruby-processing'

class Zoog < Processing::App

  def setup
    background 255 
    smooth  
    ellipse_mode CENTER 
    rect_mode CENTER  

    # Body
    stroke 0 
    fill 150 
    rect 100, 100, 20, 100 

    # Head
    fill 255 
    ellipse 100, 70, 60, 60  

    # Eyes
    fill 0  
    ellipse 81, 70, 16, 32  
    ellipse 119, 70, 16, 32 

    # Legs
    stroke 0 
    line 90, 150, 80, 160 
    line 110, 150, 120, 160 
  end
  
  def draw
  
  end
  
end

Zoog.new :title => "Zoog", :width => 200, :height => 200