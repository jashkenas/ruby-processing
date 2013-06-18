#
# WigglePShape. 
# 
# How to move the individual vertices of a PShape
#

load_library 'wiggler'

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


