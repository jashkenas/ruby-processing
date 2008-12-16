require 'ruby-processing'

class SimpleSolarSystemSketch < Processing::App

  def setup
    smooth
    @theta = 0
  end

  def draw
    background 255
    stroke 0

    # Translate to center of window to draw the sun.
    translate width/2, height/2
    fill 255, 200, 50
    ellipse 0, 0, 20, 20

    # The earth rotates around the sun
    push_matrix 
    rotate @theta
    translate 50, 0
    fill 50, 200, 255
    ellipse 0, 0, 10, 10

    # Moon #1 rotates around the earth
    # push_matrix is called to save the transformation state before drawing moon #1. 
    # This way we can pop and return to earth before drawing moon #2. 
    # Both moons rotate around the earth  which itself is rotating around the sun).
    push_matrix  
    rotate -@theta*4
    translate 15, 0
    fill 50, 255, 200
    ellipse 0, 0, 6, 6
    pop_matrix 

    # Moon #2 also rotates around the earth
    push_matrix 
    rotate @theta*2
    translate 25, 0
    fill 50, 255, 200
    ellipse 0, 0, 6, 6
    pop_matrix 

    pop_matrix 

    @theta += 0.01;
  end

end

SimpleSolarSystemSketch.new :title => "Simple Solar System", :width => 200, :height => 200

