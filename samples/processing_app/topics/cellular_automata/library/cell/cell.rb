class Cell

  attr_reader :outer, :x, :y, :width, :height, :black
  attr_reader :spore1, :spore2, :spore3, :spore4
  
  def initialize(outer, xin = 0, yin = 0)
    @outer, @x, @y = outer, xin, yin
    @width, @height, @black = outer.width, outer.height, outer.black
    @spore1, @spore2, @spore3, @spore4 = *outer.colours
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
    my_color = outer.getpix(x, y)
    if (my_color == spore1)
      if (outer.getpix(x - 1, y + 1) == black && outer.getpix(x + 1, y + 1) == black && outer.getpix(x, y + 1) == black)
        move(0, 1)
      elsif (outer.getpix(x - 1, y) == spore2 && outer.getpix(x - 1, y - 1) != black)
        move(0, -1)
      elsif (outer.getpix(x - 1, y) == spore2 && outer.getpix(x - 1, y - 1) == black)
        move(-1, -1)
      elsif (outer.getpix(x + 1, y) == spore1 && outer.getpix(x + 1, y - 1) != black)
        move(0, -1)
      elsif (outer.getpix(x + 1, y) == spore1 && outer.getpix(x + 1, y - 1) == black)
        move(1, -1)
      else
        move(rand(1 .. 2), 0)
      end
    elsif (my_color == spore2)
      if (outer.getpix(x - 1, y + 1) == black && outer.getpix(x + 1, y + 1) == black && outer.getpix(x, y + 1) == black)
        move(0, 1)
      elsif (outer.getpix(x + 1, y) == spore1 && outer.getpix(x + 1, y - 1) != black)
        move(0, -1)
      elsif (outer.getpix(x + 1, y) == spore1 && outer.getpix(x + 1, y - 1) == black)
        move(1, -1)
      elsif (outer.getpix(x - 1, y) == spore2 && outer.getpix(x - 1, y - 1) != black)
        move(0, -1)
      elsif (outer.getpix(x - 1, y) == spore2 && outer.getpix(x - 1, y - 1) == black)
        move(-1, -1)
      else
        move(rand(1 .. 2), 0)
      end
    elsif (my_color == spore3)
      if (outer.getpix(x - 1, y - 1) == black && outer.getpix(x + 1, y - 1) == black && outer.getpix(x, y - 1) == black)
        move(0, -1)
      elsif (outer.getpix(x - 1, y) == spore4 && outer.getpix(x - 1, y + 1) != black)
        move(0, 1)
      elsif (outer.getpix(x - 1, y) == spore4 && outer.getpix(x - 1, y + 1) == black)
        move(-1, 1)
      elsif (outer.getpix(x + 1, y) == spore3 && outer.getpix(x + 1, y + 1) != black)
        move(0, 1)
      elsif (outer.getpix(x + 1, y) == spore3 && outer.getpix(x + 1, y + 1) == black)
        move(1, 1)
      else
        move(rand(1 .. 2), 0)
      end
    elsif (my_color == spore4)
      if (outer.getpix(x - 1, y - 1) == black && outer.getpix(x + 1, y - 1) == black && outer.getpix(x, y - 1) == black)
        move(0, -1)
      elsif (outer.getpix(x + 1, y) == spore3 && outer.getpix(x + 1, y + 1) != black)
        move(0, 1)
      elsif (outer.getpix(x + 1, y) == spore3 && outer.getpix(x + 1, y + 1) == black)
        move(1, 1)
      elsif (outer.getpix(x - 1, y) == spore4 && outer.getpix(x - 1, y + 1) != black)
        move(0, 1)
      elsif (outer.getpix(x - 1, y) == spore4 && outer.getpix(x - 1, y + 1) == black)
        move(-1, 1)
      else
        move(rand(1 .. 2), 0)
      end
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

