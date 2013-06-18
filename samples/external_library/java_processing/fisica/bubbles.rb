#
#  Buttons and bodies
#  by Ricard Marxer
#  This example shows how to create a blob.
#
#  set_fill and set_stroke methods are missing
#  when run using builtin jruby-complete yet work
#  OK when using an external jruby
#
load_library :fisica
include_package 'fisica'

CIRCLE_COUNT = 20
HOLE = 50
TOP_MARGIN = 50
BOTTOM_MARGIN = 300
SIDE_MARGIN = 100


attr_reader :world, :x_pos

def setup
  size(400, 400)
  smooth
  @x_pos = 0
  Fisica.init(self)  
  @world = FWorld.new
  world.setGravity(0, -300)
  l = FPoly.new
  l.vertex(width/2-HOLE/2, 0)
  l.vertex(0, 0)
  l.vertex(0, height)
  l.vertex(0 + SIDE_MARGIN, height)
  l.vertex(0 + SIDE_MARGIN, height-BOTTOM_MARGIN)
  l.vertex(width/2-HOLE/2, TOP_MARGIN)
  l.set_static(true)  
  l.set_fill(0)
  l.set_friction(0)
  world.add(l)
  
  r = FPoly.new
  r.vertex(width/2 + HOLE/2, 0)
  r.vertex(width, 0)
  r.vertex(width, height)
  r.vertex(width-SIDE_MARGIN, height)
  r.vertex(width-SIDE_MARGIN, height-BOTTOM_MARGIN)
  r.vertex(width/2 + HOLE/2, TOP_MARGIN)
  r.set_static(true)
  r.set_fill(0)
  r.set_friction(0)
  world.add(r)
end

def draw
  background(80, 120, 200)
  fill(0)
  if ((frame_count % 40) == 1)
    b = FBlob.new
    s = rand(30 .. 40)
    space = (width - SIDE_MARGIN * 2-s)
    @x_pos = (x_pos + rand(s .. space/2.0)) % space
    b.set_as_circle(SIDE_MARGIN + x_pos + s / 2, height - rand(100), s, 20)
    b.set_stroke(0)
    b.set_stroke_weight(2)
    b.set_fill(255)
    b.set_friction(0)
    world.add(b)
  end
  
  world.step
  world.draw
end


def key_pressed
  save_frame("screenshot.png")
end



