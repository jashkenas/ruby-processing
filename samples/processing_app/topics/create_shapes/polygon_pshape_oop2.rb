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
  smooth
  # Make a PShape
  star = createShape
  star.beginShape
  star.noStroke
  star.fill(0, 127)
  star.vertex(0, -50)
  star.vertex(14, -20)
  star.vertex(47, -15)
  star.vertex(23, 7)
  star.vertex(29, 40)
  star.vertex(0, 25)
  star.vertex(-29, 40)
  star.vertex(-23, 7)
  star.vertex(-47, -15)
  star.vertex(-14, -20)
  star.endShape(CLOSE)

  @polygons = []
  
  # Add a bunch of objects to the ArrayList
  # Pass in reference to the PShape
  # We coud make polygons with different PShapes
  25.times do
    polygons << Polygon.new(star, width, height)
  end
end

def draw
  background(255)

  # Display and move them all
  polygons.each do |poly|
    poly.display
    poly.move
  end
end

