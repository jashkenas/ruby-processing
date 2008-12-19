require 'ruby-processing'

class NestedPushAndPopSketch < Processing::App

  def setup
    smooth
    @theta = 0  # angle for rotation
  end

  def draw
    background 255
    stroke 0

    # Translate to center of window
    translate width/2, height/2

    # Loop from 0 to 360 degrees (2*PI radians)
    0.step(TWO_PI, 0.2) do |i| 

      # Push, rotate and draw a line!
      # The transformation state is saved at the beginning of each cycle through the for loop and restored at the end. 
      # Try commenting out these lines to see the difference!
      push_matrix  
      rotate @theta + i
      line 0, 0, 100, 0

      # Loop from 0 to 360 degrees (2*PI radians)
      0.step(TWO_PI, 0.5) do |j| 
        # Push, translate, rotate and draw a line!
        push_matrix 
        translate 100, 0
        rotate -@theta - j
        line 0, 0, 50, 0
        # We're done with the inside loop,pop!
        pop_matrix 
      end

      # We're done with the outside loop, pop!
      pop_matrix 
    end
    end_shape 

    # Increment @theta
    @theta += 0.01
  end

end

NestedPushAndPopSketch.new :title => "Nested Push and Pop", :width => 200, :height => 200

