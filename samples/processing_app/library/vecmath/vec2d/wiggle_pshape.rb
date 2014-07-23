#
# WigglePShape. Demonstrates initialization and use of ShapeRender,
# that allows us to send Vec2D to PShape vertex
# 
# How to move the individual vertices of a PShape
#
load_library :vecmath

attr_reader :wiggler

def setup
  size(640, 360, P2D)
  @wiggler = Wiggler.new width, height
end

def draw
  background(255)
  wiggler.display
  wiggler.wiggle
end

# An object that wraps the PShape


class Wiggler
  include Processing::Proxy
  attr_reader :original, :x, :y, :s, :yoff, :xoff, :renderer

  def initialize width, height
    @x = width/2
    @y = height/2 
    @yoff = 0
    
    # The "original" locations of the vertices make up a circle

    @original = (0 ... 16).map{|a| Vec2D.from_angle(PI * a / 8) * 100}
    
    # Now make the PShape with those vertices
    @s = create_shape
    @renderer = ShapeRender.new(s)
    s.begin_shape
    s.fill(127)
    s.stroke(0)
    s.stroke_weight(2)
    original.map{|v| v.to_vertex(renderer)}
    s.end_shape(CLOSE)
  end

  def wiggle
    @xoff = 0
    # Apply an offset to each vertex
    rad = ->(pos){(Vec2D.from_angle(TAU * noise(xoff, yoff)) * 4) + pos}
    
    original.each_with_index do |pos, i| 
      # Calculate a new vertex location based on noise around "original" location
      r = rad.call(pos)
      # Set the location of each vertex to the new one
      s.set_vertex(i, r.x, r.y)
      # increment perlin noise x value
      @xoff += 0.5
    end
    # Increment perlin noise y value
    @yoff += 0.02
  end

  def display
    push_matrix
    translate(x, y)
    shape(s)
    pop_matrix
  end
end


