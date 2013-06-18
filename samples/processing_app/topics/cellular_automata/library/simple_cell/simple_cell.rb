class Cell
  
  attr_reader :outer, :x, :y, :width, :height, :black
  attr_reader :spore_colour
  
  def initialize(outer, xin = 0, yin = 0)
    @outer, @x, @y = outer, xin, yin
    @width, @height, @black = outer.width, outer.height, outer.black
    @spore_colour = outer.spore_colour
  end
  
  # Perform action based on surroundings
  def run
    # Fix cell coordinates
    while (x < 0)
      @x += width
    end
    while (x > (width - 1))
      @x -= width
    end
    while (y < 0)
      @y += height
    end
    while (y > (height - 1))
      @y -= height
    end
    # Cell instructions
    if (outer.getpix(x + 1, y) == black)
      move(0, 1)
    elsif (outer.getpix(x, y - 1) != black && outer.getpix(x - 1, y - 1) != black)
      move(rand(-4 .. 4), rand(-4 .. 4))     
    end
  end
  
  # Will move the cell (dx, dy) units if that space is empty
  def move(dx, dy)
    if (outer.getpix(x + dx, y + dy) == black)
      outer.setpix(x + dx, y + dy, outer.getpix(x, y))
      outer.setpix(x, y, black)
      @x += dx
      @y += dy
    end
  end
end
  

