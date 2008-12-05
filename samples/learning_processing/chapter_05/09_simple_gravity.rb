require 'ruby-processing'

class SimpleGravity < Processing::App

  def setup
    @x, @y = 100, 0 # x and y locations of square
    @speed = 0.0  # speed of square
    
    # A new variable,  for gravity (i.e. acceleration).   
    # We use a relatively small number (0.1) because this 
    # accelerations accumulates over time, increasing the speed.   
    # Try changing this number to 2.0 and see what happens.
    @gravity = 0.1
  end
  
  def draw
    background 255
    
    # Display the square
    fill 175
    stroke 0
    rect_mode CENTER
    rect @x, @y, 10, 10
    
    # Add speed to location
    @y += @speed
    
    # Add gravity to speed
    @speed += @gravity
    
    # If square reaches the bottom
    # Reverse speed
    @speed *= -0.95 if @y > @height
    # Multiplying by -0.95 instead of -1 slows the square down 
    # each time it bounces (by decreasing speed).  
    # This is known as a "dampening" effect and is a more realistic 
    # simulation of the real world (without it, a ball would bounce forever).
  
  end
  
end

SimpleGravity.new :title => "Simple Gravity", :width => 200, :height => 200