# GLSL version of Conway's game of life, ported from GLSL sandbox:
# http://glsl.heroku.com/e/207.3
# Exemplifies the use of the buffer uniform in the shader, that gives
# access to the previous frame.
attr_accessor :pg, :conway

def setup
  size(400, 400, P3D)    
  @pg = createGraphics(400, 400, P2D)
  pg.no_smooth
  @conway = load_shader("data/conway.glsl")
  conway.set("resolution", width.to_f, height.to_f)  
end

def draw
  conway.set("time", millis() / 1000.0)  
  xm = map(mouse_x, 0, width, 0, 1)
  ym = map(mouse_y, 0, height, 1, 0)
  conway.set("mouse", xm, ym) 
  pg.begin_draw
  pg.background(0)
  pg.shader(conway)
  pg.rect(0, 0, pg.width, pg.height)  
  pg.end_draw  
  image(pg, 0, 0, width, height)  
end
