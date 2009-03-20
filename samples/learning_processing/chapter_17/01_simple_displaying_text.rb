#
# Example 17-1: Simple displaying text
#
def setup
  size 200, 200
  # Load Font
  @f = loadFont "ArialMT-16.vlw"
end

def draw
  background 255
  textFont @f, 16 # Specify font to be used
  fill 0          # Specify font color

  # Display Text
  text "Mmmmm ... Strings ..." , 10, 100
end
