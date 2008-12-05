require 'ruby-processing'

class BouncingColor < Processing::App

  def setup
    @c1, @c2 = 1.0, 255.0
    # Start by incrementing c1 and decrementing c2.
    @c1_dir, @c2_dir = 0.1, -0.1
  end
  
  def draw
    no_stroke
    
    # Draw rectangle on left
    fill @c1, 0, @c2
    rect 0, 0, 100, 200
    
    # Draw rectangle on right
    fill @c2, 0, @c1
    rect 100, 0, 100, 200
    
    # Adjust color values
    @c1 += @c1_dir
    @c2 += @c2_dir
    
    # Instead of reaching the edge of a window, these variables reach the "edge" of color:  
    # 0 for no color and 255 for full color.  
    # When this happens, just like with the bouncing ball, the direction is reversed.
    #
    # Reverse direction of color change
    @c1_dir *= -1 if @c1 < 0 || @c1 > 255
    @c2_dir *= -1 if @c2 < 0 || @c2 > 255
  end
  
end

BouncingColor.new :title => "Bouncing Color", :width => 200, :height => 200