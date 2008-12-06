require 'ruby-processing'

class ManyLines < Processing::App

  def setup
    background 255
    
    # Legs  
    stroke 0   
    line 50, 60, 50, 80   
    line 60, 60, 60, 80   
    line 70, 60, 70, 80   
    line 80, 60, 80, 80   
    line 90, 60, 90, 80   
    line 100, 60, 100, 80   
    line 110, 60, 110, 80   
    line 120, 60, 120, 80   
    line 130, 60, 130, 80   
    line 140, 60, 140, 80   
    line 150, 60, 150, 80
  end
  
  def draw
  
  end
  
end

ManyLines.new :title => "Many Lines",  :width => 200,  :height => 200