require 'ruby-processing'

class SimpleWhileLoopWithInteractivity < Processing::App

  def setup
    # no_stroke can go inside setup, because it only needs to be called once.
    no_stroke  
  end
  
  def draw
    background 0 

    # Start with i as 0
    i = 0

    # While i is less than the width of the window
    while i < width
      # The distance between the current rectangle and the mouse 
      # is equal to the absolute value of the difference between i and mouseX.
      distance = (mouse_x - i).abs  
      # That distance is used to fill the color of a rectangle at horizontal location i.
      fill distance 
      rect i, 0, 10, height 
      # Increase i by 10
      i += 10
    end
    
    # Un-comment the following lines to perform the same procedure
    # for the height of the sketch, at half opacity.
    # Uses a slightly different technique:
    
    # (height/10).times do |j|
    #   distance = (mouse_y - j*10).abs
    #   fill distance, 128
    #   rect 0, j*10, width, 10
    # end
  end
  
end

SimpleWhileLoopWithInteractivity.new :title => "Simple While Loop With Interactivity", :width => 255, :height => 255