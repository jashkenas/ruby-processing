# hello_bot_ignore_styles.rb
# original sketch and library by Ricard Marxer
# http://www.ricardmarxer.com/geomerative/

load_library :geomerative
java_import 'geomerative.RG'

# Create a reader for the object we are going to create in setup and use in draw
attr_reader :grp 

def setup
  size 800, 600
  smooth 4
  # VERY IMPORTANT: Always initialize the library before using it
  RG::init self
  @grp = RG::load_shape "Toucan.svg"
  grp.center_in g
end 

def draw
  background 255
  translate width / 2, height / 2
  
  point_separation = map(constrain(mouse_x, 200, width - 200), 200, width - 200, 5, 300)
  
  RG.set_polygonizer RG.UNIFORMLENGTH 
  RG.set_polygonizer_length point_separation 
  new_grp = RG.polygonize grp 
  
  
  RG.ignore_styles false  
  new_grp.draw
  
  RG.ignore_styles
  no_fill
  stroke 0, 100
  grp.draw
end
