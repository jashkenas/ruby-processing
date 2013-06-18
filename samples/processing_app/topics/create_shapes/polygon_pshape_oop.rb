#
# PolygonPShapeOOP. 
# 
# Wrapping a PShape inside a custom class 
#/

load_library 'star'
# A Star object
attr_reader :s1, :s2

def setup
  size(640, 360, P2D)
  # Make a new Star
  @s1 = Star.new width, height
  @s2 = Star.new width, height
end

def draw
  background(51)
 
  s1.display # Display the first star
  s1.move    # Move the first star
  
  s2.display # Display the second star
  s2.move    # Move the second star

end


