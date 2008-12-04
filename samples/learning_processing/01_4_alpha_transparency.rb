require 'ruby-processing'

class AlphaTransparency < Processing::App

  def setup
    background 0 
    no_stroke
    
    # No fourth argument means 100% opacity
    fill 0, 0, 255
    rect 0, 0, 100, 200
    
    # 255 means 100% opacity
    fill 255, 0, 0, 255
    rect 0, 0, 200, 40
    
    # 75% opacity
    fill 255, 0, 0, 191
    rect 0, 50, 200, 40
    
    # 55% opacity
    fill 200, 0, 0, 127
    rect 0, 100, 200, 40
    
    # 25% opacity
    fill 255, 0, 0, 63
    rect 0, 150, 200, 40
  end
  
  def draw
  
  end
  
end

AlphaTransparency.new :title => "Alpha Transparency", :width => 200, :height => 200