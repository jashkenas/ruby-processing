# Words. 
# 
# The text() function is used for writing words to the screen. 

def setup    
  size 640, 360    
  @x = 30 
  PFont::list.each {|fnt| puts fnt} 
  @font = create_font("Georgia", 24)     
  text_font @font, 32    
  no_loop
end

def draw
  background(102)
  text_align(RIGHT)
  draw_type(width * 0.25)
  text_align(CENTER)
  draw_type(width * 0.5)
  text_align(LEFT);
  draw_type(width * 0.75)
end

def draw_type x    
  line(x, 0, x, 65)
  line(x, 220, x, height)   
  fill 0
  text "ichi", x, 95
  fill 51
  text "ni", x, 130
  fill 204
  text "san", x, 165
  fill 255
  text "shi", x, 210    
end

