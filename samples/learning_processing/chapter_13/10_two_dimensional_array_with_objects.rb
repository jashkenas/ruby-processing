require 'ruby-processing'

# Let's start by defining the cell class.
class Cell

  def initialize(x, y, w, h, angle)
    @x, @y = x, y
    @w, @h = w, h
    @angle = angle
  end

  # we oscillate by increasing the angle, here.
  def oscillate
    @angle += 0.02
  end

  def display
    $app.stroke 255
    # calculate color using sine wave
    $app.fill 127 + 127 * Math.sin(@angle)
    $app.rect @x, @y, @w, @h
  end
  
  def oscillate_and_display
    oscillate
    display
  end

end


# And then the sketch that holds many cells.
class ArrayWithObjectsSketch < Processing::App

  def setup
    smooth
    @cols = @rows = 20

    # initialize array with random values
    @grid = Array.new(@cols) do |i| 
      Array.new(@rows) do |j|
        Cell.new(i*20, j*20, 20, 20, i+j)
      end
    end
  end

  def draw
    background 0
    @grid.each { |array| array.each { |cell| cell.oscillate_and_display } }
  end

end

ArrayWithObjectsSketch.new :title => "Two Dimensional Array with Objects", :width => 200, :height => 200
