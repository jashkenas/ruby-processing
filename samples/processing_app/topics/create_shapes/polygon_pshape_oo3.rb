#
# PolygonPShapeOOP. 
# 
# Wrapping a PShape inside a custom class 
# and demonstrating how we can have a multiple objects each
# using the same PShape.
#
load_library 'polygon'

# A list of objects
attr_reader :polygons

def setup
  size(640, 360, P2D)
  smooth()
  shapes = []
  shapes[0] = create_shape(ELLIPSE,0,0,100,100)
  shapes[0].set_fill(color(255, 127))
  shapes[0].set_stroke(false)
  shapes[1] = create_shape(RECT,0,0,100,100)
  shapes[1].set_fill(color(255, 127))
  shapes[1].set_stroke(false)
  shapes[2] = create_shape()  
  shapes[2].begin_shape()
  shapes[2].fill(0, 127)
  shapes[2].no_stroke()
  shapes[2].vertex(0, -50)
  shapes[2].vertex(14, -20)
  shapes[2].vertex(47, -15)
  shapes[2].vertex(23, 7)
  shapes[2].vertex(29, 40)
  shapes[2].vertex(0, 25)
  shapes[2].vertex(-29, 40)
  shapes[2].vertex(-23, 7)
  shapes[2].vertex(-47, -15)
  shapes[2].vertex(-14, -20)
  shapes[2].end_shape(CLOSE)

  # Make an ArrayList
  @polygons = []
  
  25.times do
    polygons << Polygon.new(shapes[rand(shapes.length)], width, height)  
  end
end

def draw
  background(102)

  # Display and move them all
  polygons.each do |poly|
    poly.run
  end
end

