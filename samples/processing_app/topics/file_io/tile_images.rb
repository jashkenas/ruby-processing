#
# Tile Images
# 
# Draws an image larger than the screen by tiling it into small sections.
# The scaleValue variable sets amount of scaling: 1 is 100%, 2 is 200%, etc.
#
attr_reader :scaleValue, :x_offset, :y_offset


def setup
  size(600, 600)
  stroke(0, 100)
  @x_offset = 0     # x-axis offset
  @y_offset = 0     # y-axis offset
  @scaleValue = 3  # Multiplication factor
end

def draw
  scale(scaleValue)
  translate(x_offset * (-width / scaleValue), y_offset * (-height / scaleValue))
  line(10, 150, 500, 50)
  line(0, 600, 600, 0)
  setOffset
end

def setOffset
  save("lines-#{x_offset}#{y_offset}.png")
  @x_offset += 1
  if (x_offset == scaleValue)
    @x_offset = 0
    @y_offset += 1
    if (y_offset == scaleValue)
      exit
    end
  end
  background(204)
end
