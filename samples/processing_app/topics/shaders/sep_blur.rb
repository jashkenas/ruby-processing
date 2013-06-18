#
# Separate Blur Shader
# 
# This blur shader works by applying two successive passes, one horizontal
# and the other vertical.
# 
#

attr_reader :blur, :src, :pass1, :pass2

def setup
  size(640, 360, P2D)  
  @blur = load_shader("sep_blur.glsl")
  blur.set("blurSize", 9)
  blur.set("sigma", 5.0)  
  @src = create_graphics(width, height, P2D)  
  @pass1 = create_graphics(width, height, P2D)
  pass1.no_smooth  
  @pass2 = create_graphics(width, height, P2D)
  pass2.no_smooth
end

def draw
  src.begin_draw
  src.background(0)
  src.fill(255)
  src.ellipse(width/2, height/2, 150, 150)
  src.end_draw
  
  # Applying the blur shader along the vertical direction   
  blur.set("horizontalPass", 0)
  pass1.begin_draw            
  pass1.shader(blur)  
  pass1.image(src, 0, 0)
  pass1.end_draw
  
  # Applying the blur shader along the horizontal direction      
  blur.set("horizontalPass", 1)
  pass2.begin_draw            
  pass2.shader(blur)  
  pass2.image(pass1, 0, 0)
  pass2.end_draw  
  image(pass2, 0, 0)   
end

def key_pressed
  case(key)
  when '9'
    blur.set("blurSize", 9)
    blur.set("sigma", 5.0)
  when '7'
    blur.set("blurSize", 7)
    blur.set("sigma", 3.0)
  when '5' 
    blur.set("blurSize", 5)
    blur.set("sigma", 2.0)  
  when '3'
    blur.set("blurSize", 5)
    blur.set("sigma", 1.0)  
  else
    blur.set("blurSize", 9)
    blur.set("sigma", 5.0)
  end  
end 
