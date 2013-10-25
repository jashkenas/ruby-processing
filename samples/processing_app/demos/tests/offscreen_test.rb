attr_reader :pg

def setup
  size(400, 400, P3D)
  @pg = createGraphics(400, 400, P3D)
  pg.smooth(4)
end

def draw
  background(0)
  pg.begin_draw
  pg.background(255, 0, 0)
  pg.ellipse(mouse_x, mouse_y, 100, 100)
  pg.end_draw
  image(pg, 0, 0, 400, 400)
end

def key_pressed 
  case key
  when '1'
    pg.smooth(1)
  when '2'
    pg.smooth(2)
  when '3'
    pg.smooth(4)
  when '4'
    pg.smooth(8)
  when '5'
    pg.smooth(16)
  when '6'
    pg.smooth(32)
  end
end

