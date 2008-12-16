require 'ruby-processing'

class Cell

  def initialize(x, y, w, h, angle)
    @x = x
    @y = y
    @w = w
    @h = h
    @angle = angle
  end

  def oscillate
    @angle += 0.2
  end

  def display(app)
    app.stroke 255
    # calculate colour using sin wave
    app.fill 127 + 128 * Math::sin(@angle)
    app.rect @x, @y, @w, @h
  end

end

class TwoDimensionalArrayWithObjectsSketch < Processing::App

  def setup
    smooth
    @cols = @rows = 20

    # initializse array with random values
    @grid = Array.new(@cols) { Array.new(@rows) { nil }}
    
    # draw the points
    @cols.times do |i|
      @rows.times do |j|
        @grid[i][j] = Cell.new(i * (width / @cols), j * (height / @rows), width / @cols, height / @rows, i + j)
        point i, j
      end
    end
  end

  def draw
    background 0

    @cols.times do |i|
      @rows.times do |j|
        # oscillate and display each object
        @grid[i][j].oscillate
        @grid[i][j].display($app)
      end
    end
  end

end

TwoDimensionalArrayWithObjectsSketch.new :title => "Two Dimensional Array with Objects", :width => 400, :height => 400
