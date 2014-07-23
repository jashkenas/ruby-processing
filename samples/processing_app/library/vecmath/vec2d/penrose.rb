# Penrose Tile Generator
# Using a variant of the "ArrayList" recursion technique: http://natureofcode.com/book/chapter-8-fractals/chapter08_section4
# Penrose Algorithm from: http://preshing.com/20110831/penrose-tiling-explained
# Daniel Shiffman May 2013
# Translated (and refactored) to ruby-processing Jan 2014 by Martin Prout

load_libraries :vecmath, :tile, :control_panel
attr_reader :tris, :s, :panel, :hide, :acute

def setup
  size(1024, 576)
  control_panel do |c|
    c.title = 'Tiler Control'
    c.look_feel 'Nimbus'
    c.checkbox  :seed
    c.checkbox  :acute
    c.button    :generate
    c.button    :reset!
    @panel = c
  end
  @hide = false
  init false # defaults to regular penrose
end

def draw
  # only make control_panel visible once, or again when hide is false
  unless hide
    @hide = true
    panel.set_visible(hide)
  end
  background(255)
  translate(width / 2, height / 2)
  tris.each do |t|
    t.display
  end
end

def generate
  next_level = []
  tris.each do |t|
    more = t.subdivide
    more.each do |m|
      next_level << m
    end
  end
  @tris = next_level
end

def reset!
  Tiler.acute(acute)  # set the Tiler first
  init @seed
  java.lang.System.gc # but does it do any good?
end

def init(alt_seed)
  @tris = []
  10.times do |i|     # create 36 degree segments
    a = Vec2D.new
    b = Vec2D.from_angle((2 * i - 1) * PI / 10)
    c = Vec2D.from_angle((2 * i + 1) * PI / 10)
    b *= 370
    c *= 370
    if alt_seed
      tile = i.even? ? Tiler.tile(b, a, c) : Tiler.tile(c, a, b)
      tris << tile
    else
      tile = i.even? ? Tiler.tile(a, b, c) : Tiler.tile(a, c, b)
      tris << tile
    end
  end
end
