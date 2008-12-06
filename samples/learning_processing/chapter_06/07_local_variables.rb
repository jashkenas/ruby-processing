require 'ruby-processing'

class LocalVariables < Processing::App

  def setup
    # x is not available! It is local to the draw block of code.
  end
  
  def draw
    background 0 
    x = 0
    # x is available! Since it is declared within the draw
    # block of code, it is available here. 
    # Notice, however, that it is not available inside draw 
    # above where it is declared. 
    # Also, it is available inside the while block of code 
    # because while is inside of draw.
    
    while x < width
      stroke 255 
      line x, 0, x, height 
      x += 5
    end
    
    # This could also be written with until:
    # until x > width ...
    # Or it could be written with step:
    # 0.step(width, 5) do ...
    
  end
  
  def mouse_pressed
    # x is not available! It is local to the draw block of code.
    puts "The mouse was pressed!" 
  end
   
end

LocalVariables.new :title => "Local Variables", :width => 200, :height => 200