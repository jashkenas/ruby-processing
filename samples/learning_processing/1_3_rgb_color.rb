require 'ruby-processing'

# RGB color is specified by intensity of red, then green, then blue.
class RgbColor < Processing::App

  def setup
    smooth
    
    background 255
    no_stroke
    
    # Bright red
    fill 255, 0, 0
    ellipse 20, 20, 16, 16
    
    # Dark red
    fill 127, 0, 0
    ellipse 40, 20, 16, 16
    
    # Pink
    fill 255, 200, 200
    ellipse 60, 20, 16, 16
  end
  
  def draw
  
  end
  
end

RgbColor.new :title => "Rgb Color", :width => 200, :height => 200