#
# Blending 
# by Andres Colubri. 
# 
# Images can be blended using one of the 10 blending modes 
# (currently available only in P2D and P3).
# Click to go to cycle through the modes.  
#

# NOTE: THIS EXAMPLE IS IN PROGRESS -- REAS

attr_reader  :img1, :img2, :pic_alpha, :name, :sel_mode


def setup
  size(640, 360, P3D)
  @img1 = loadImage("layer1.jpg")
  @img2 = loadImage("layer2.jpg") 
  @name = "REPLACE"
  noStroke
  @sel_mode = REPLACE
end

def draw
  
  @pic_alpha = (map(mouse_x, 0, width, 0, 255)).to_i
  
  background(0)
  
  tint(255, 255)
  image(img1, 0, 0)
  
  blend_mode(sel_mode)  
  tint(255, pic_alpha)
  image(img2, 0, 0)
  
  blend_mode(REPLACE) 
  fill(255)
  rect(0, 0, 94, 22)
  fill(0)
  text(name, 10, 15)
end

def mouse_pressed
  if (sel_mode == REPLACE) 
    @sel_mode = BLEND
    @name = "BLEND"
  elsif (sel_mode == BLEND) 
    @sel_mode = ADD
    @name = "ADD"
  elsif (sel_mode == ADD) 
    @sel_mode = SUBTRACT
    @name = "SUBTRACT"
  elsif (sel_mode == SUBTRACT) 
    @sel_mode = LIGHTEST
    @name = "LIGHTEST"
  elsif (sel_mode == LIGHTEST) 
    @sel_mode = DARKEST
    @name = "DARKEST"
  elsif (sel_mode == DARKEST) 
    @sel_mode = DIFFERENCE
    @name = "DIFFERENCE"
  elsif (sel_mode == DIFFERENCE) 
    @sel_mode = EXCLUSION  
    @name = "EXCLUSION"
  elsif (sel_mode == EXCLUSION) 
    @sel_mode = MULTIPLY  
    @name = "MULTIPLY"
  elsif (sel_mode == MULTIPLY) 
    @sel_mode = SCREEN
    @name = "SCREEN"
  elsif (sel_mode == SCREEN) 
    @sel_mode = REPLACE
    @name = "REPLACE"
  end
end

def mouse_dragged
  if (height - 50 < mouse_y)
    @pic_alpha = (map(mouse_x 0, width, 0, 255)).to_i
  end
end
