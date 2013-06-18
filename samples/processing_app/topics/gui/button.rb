#
# Button. 
# 
# Hover on one of the colored objects in the 
# center of the image to change their color 
#

RECT_SIZE = 90     # Diameter of rect
CIRCLE_SIZE = 93   # Diameter of circle
attr_reader :rect_color, :circle_color, :rect_highlight, :circle_highlight
attr_reader :base_color, :current_color, :rect_x, :rect_y, :circle_x, :circle_y
attr_reader :rect_over, :circle_over

def setup
  size(640, 360)
  smooth(4)
  @rect_color = color(0)
  @rect_highlight = color(51)
  @circle_color = color(255)
  @circle_highlight = color(204)
  @base_color = color(102)
  @current_color = base_color
  @circle_x = (width + CIRCLE_SIZE) / 2 + 10
  @circle_y = height/2
  @rect_x = width/2 - RECT_SIZE - 10
  @rect_y = height/2 - RECT_SIZE / 2
  ellipse_mode(CENTER)
end

def draw
  update(mouse_x, mouse_y)
  background(current_color)
  
  if (rect_over)
    fill(rect_highlight)
  else
    fill(rect_color)
  end
  stroke(255)
  rect(rect_x, rect_y, RECT_SIZE, RECT_SIZE)
  
  if (circle_over)
    fill(circle_highlight)
  else
    fill(circle_color)
  end
  stroke(0)
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

def mouse_pressed  
  @current_color = (circle_over)? circle_color : (rect_over)? 
  rect_color : current_color 
end

def over_rect?(x, y, width, height)
  (mouse_x >= x && mouse_x <= x + width && mouse_y >= y && mouse_y <= y + height)
end

def over_circle?(x, y, diameter)
  dis_x = x - mouse_x
  dis_y = y - mouse_y
  (sqrt(sq(dis_x) + sq(dis_y)) < diameter/2 )
end
