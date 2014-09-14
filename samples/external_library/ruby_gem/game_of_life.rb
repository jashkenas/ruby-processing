# game_of_life.rb featuring MDArray in ruby-processing
# A Processing implementation of Game of Life
# By Joan Soler-Adillon
#
# Press SPACE BAR to pause and change the cell's values with the mouse
# On pause, click to activate/deactivate cells
# Press R to randomly reset the cells' grid
# Press C to clear the cells' grid
#
# The original Game of Life was created by John Conway in 1970.
#

require 'mdarray'

CELL_SIZE = 5
ALIVE = true
DEAD = false
ALIVE_START = 150
WIDTH = 960
HEIGHT = 640
SKIP = 10
INTERVAL = 100

attr_reader :pause, :cells, :row, :column, :last_time, :alive, :cells_buffer

def setup
  size WIDTH, HEIGHT
  @row = WIDTH / CELL_SIZE
  @column = HEIGHT / CELL_SIZE
  background 0
  stroke_weight 2
  @last_time = 0
  @pause = false
  @cells = MDArray.boolean([row, column], random_data)
  @alive = color(100, 255, 100)
  stroke(48, 100)
  no_smooth
end

def draw
  background(0)
  #Draw live cells
  (0 ... row).each do |x|
    (0 ... column).each do |y|
      if (cells.get([x, y]))
        fill(alive)
        rect(x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
      end
    end
  end
  # Iterate if timer ticks
  if (millis - last_time > INTERVAL)
    if (!pause)
      tick!
      @last_time = millis
    end
  end
  
  # Create  new cells manually on pause
  if (pause && mouse_pressed?)
    # # Map and avoid out of bound errors
    x_cell_over = (map(mouse_x, 0, width, 0, row)).to_i
    x_cell_over = constrain(x_cell_over, 0, row - 1)
    y_cell_over = (map(mouse_y, 0, height, 0, column)).to_i
    y_cell_over = constrain(y_cell_over, 0, column - 1)
    
    # Check against cells in buffer
    if (cells_buffer.get([x_cell_over, y_cell_over]))  # Cell is alive
      cells.set([x_cell_over, y_cell_over], DEAD) # Kill
      fill(0) #reflect changed status
    else  # Cell is dead
      cells.set([x_cell_over, y_cell_over], ALIVE) # Make alive
      fill(alive) # Fill alive color
    end
    
  elsif (pause && !mouse_pressed?)  # And then save to buffer once mouse goes up
    # Save cells to buffer (so we operate with one array keeping the other intact)
    @cells_buffer = cells.copy
  end
end

def tick!  # When the clock ticks
  # Save cells to buffer (so we operate with one array keeping the other intact)
  @cells_buffer = cells.copy
  # Visit each cell:
  (0 ... row).each do |x|
    (0 ... column).each do |y|
      # And visit all the neighbours of each cell
      neighbours = 0 # We'll count the neighbours
      (x - 1..x + 1).each do |xx|
        (y - 1..y + 1).each do |yy|
          # Make sure you are not out of bounds
          if [(xx>=0), (xx<row), (yy>=0), (yy<column)].all? {|in_bounds| in_bounds == true}
            # Make sure to check against self
            if ![(xx == x), (yy == y)].all? {|is_self| is_self == true}
              if (cells_buffer.get([xx, yy])) # true == ALIVE
                neighbours += 1 # Check alive neighbours and count them
              end # alive
            end # End of if self
          end # End of if grid bounds
        end # End of yy loop
      end #End of xx loop
      # We've checked the neighbours: apply rules in one line (only in ruby)!
      cells.set([x, y], (cells_buffer.get([x, y]))?  ((2..3) === neighbours) : (neighbours == 3))
    end # End of y loop
  end # End of x loop
end # End of function

def key_pressed
  case key
  when 'r', 'R'
    # Restart: reinitialization of cells 
    @cells = MDArray.boolean([row, column], random_data)
  when ' ' # On/off of pause
    @pause = !pause
  when 'c', 'C' # Clear all
    @cells = MDArray.boolean([row, column], DEAD)
  end
end

def random_data
  data = []
  (0 ... row * column).each do
    data << (rand(1000) < ALIVE_START)
  end
  return data
end
