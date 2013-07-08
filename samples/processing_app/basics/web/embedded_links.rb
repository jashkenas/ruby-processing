# Loading URLs. 
# 
# Click on the left button to open a different URL in the same window (Only
# works online). Click on the right button to open a URL in a new browser window.  

def setup
  
  size 640, 360
  
end

def draw
  size 200, 200
  background 204  	
  no_fill
  fill 255 if @over_left_button
  
  rect 20, 60, 75, 75
  rect 50, 90, 15, 15
  
  no_fill
  fill 255 if @over_right_button
  
  rect 105,  60,  75,  75
  line 135, 105, 155,  85
  line 140,  85, 155,  85
  line 155,  85, 155, 100
  
end

def mouse_pressed
  link "https://github.com/jashkenas/ruby-processing/wiki" if @over_left_button
  link "https://github.com/jashkenas/ruby-processing/wiki", "_new" if @over_right_button
end

def mouse_moved 
  check_buttons 
end

def mouse_dragged
  check_buttons
end

def check_buttons
  @over_left_button  = inside? mouse_x, mouse_y,  20,  95, 60, 135
  @over_right_button = inside? mouse_x, mouse_y, 105, 180, 60, 135
end

def inside? ( x, y, l, r, t, b )
  return x > l && x < r && y > t && y < b
end

