# hola_mundo.rb
# original sketch and library by Ricard Marxer
# http://www.ricardmarxer.com/geomerative/

load_library :geomerative
java_import 'geomerative.RG'

# Create a reader for the object we are going to create in setup and use in draw
attr_reader :grp

def setup
  # Initialize the sketch
  size 600, 400
  
  # VERY IMPORTANT: Always initialize the library in the setup
  RG::init(self)

  # Set fill stroke colours
  fill(255, 102, 0)
  stroke(0)
  
  #  Load the font file we want to use (the file must be in the data folder in the sketch folder),
  #  with the size 72 and the alignment CENTER
  @grp = RG::get_text("Hola Mundo!", "FreeSans.ttf", 72, CENTER)
end

def draw
  # Clear frame
  background(255)
  
  # Set the origin to draw in the middle of the sketch
  translate width / 2, height / 2
  
  # Draw the string "Hola Mundo!" on the PGraphics canvas g 
  # (which is the default canvas of the sketch)  
  grp.draw
end
