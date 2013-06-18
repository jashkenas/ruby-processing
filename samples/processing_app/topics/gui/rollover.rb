#
# Button. 
# 
# Click on one of the colored squares in the 
# center of the image to change the color of 
# the background. 
#

RECT_SIZE = 90     # Diameter of rect
CIRCLE_SIZE = 93   # Diameter of circle
attr_reader :rect_color, :circle_color, :base_color
attr_reader :base_color, :rect_x, :rect_y, :circle_x, :circle_y
attr_reader :rect_over, :circle_over

def setup
  size(640, 360)
  smooth(4)
  @rect_color = color(0)
  @circle_color = color(255)
  @base_color = color(102)
  @circle_x = (width + CIRCLE_SIZE) / 2 + 10
  @circle_y = height/2
  @rect_x = width/2 - RECT_SIZE - 10
  @rect_y = height/2 - RECT_SIZE / 2
  ellipse_mode(CENTER)
end

def draw
  update(mouse_x, mouse_y) 
  if (rect_over) 
    background(rect_color)
  elsif (circle_over) 
    background(circle_color)
  else 
    background(base_color)
  end
  stroke(255)
  fill(rect_color)
  rect(rect_x, rect_y, RECT_SIZE, RECT_SIZE) 
  stroke(0)
  fill(circle_color)
  ellipse(circle_x, circle_y, CIRCLE_SIZE, CIRCLE_SIZE)
end

def update(x, y)
  if over_circle?(circle_x, circle_y, CIRCLE_SIZE) 
    @circle_over, @rect_over = true, false
  elsif over_rect?(rect_x, rect_y, RECT_SIZE, RECT_SIZE) 
    @circle_over, @rect_over = false, true
  else
    @circle_over, @rect_over = false, false
  end
end

def over_rect?(x, y, width, height)
  (mouse_x >= x && mouse_x <= x + width && mouse_y >= y && mouse_y <= y + height)
end

def over_circle?(x, y, diameter)
  dis_x = x - mouse_x
  dis_y = y - mouse_y
  (sqrt(sq(dis_x) + sq(dis_y)) < diameter/2 )
end
