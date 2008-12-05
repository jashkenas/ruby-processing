require 'ruby-processing'

class Rollovers < Processing::App

  def setup
  
  end
  
  def draw
    background 255
    stroke 0
    line 100, 0, 100, 200
    line 0, 100, 200, 100
    
    # Fill a black color
    no_stroke
    fill 0
    
    # Depending on the mouse location, a different rectangle is displayed.    
    if mouse_x < 100 && mouse_y < 100
      rect 0, 0, 100, 100
    elsif mouse_x > 100 && mouse_y < 100
      rect 100, 0, 100, 100
    elsif mouse_x < 100 && mouse_y > 100
      rect 0, 100, 100, 100
    elsif mouse_x > 100 && mouse_y > 100
      rect 100, 100, 100, 100
    end
    
  end
  
end

Rollovers.new :title => "Rollovers", :width => 200, :height => 200