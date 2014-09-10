# hello_world_rotate.rb
# original sketch and library by Ricard Marxer
# http://www.ricardmarxer.com/geomerative/

load_library :geomerative
java_import 'geomerative.RG'

# Create a reader for the object we are going to create in setup and use in draw
attr_reader :grp

def setup
  # Initialize the sketch
  size 600, 400
  frame_rate 24

  # VERY IMPORTANT: Always initialize the library in the setup
  RG::init(self)

  # Set colors

  fill(255,102,0)
  stroke(0)

  #  Load the font file we want to use (the file must be in the data folder in the sketch floder),
  #  with the size 72 and the alignment CENTER
  @grp = RG::get_text("Hola Mundo!", "FreeSans.ttf", 72, CENTER)
  smooth 4
end

def draw
  # Clean frame
  background(255)

  # Set the origin to draw in the middle of the sketch
  translate width / 2, height / 2

  # Transform at each frame the first letter with a PI/20 radians
  # rotation around the center of the first letter's center
  grp.children[0].rotate(PI / 20, grp.children[0].get_center)

  # Draw the group of shapes representing "Hola Mundo!" on the PGraphics canvas g (which is the default canvas of the sketch)
  grp.draw
end
